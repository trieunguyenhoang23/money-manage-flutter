import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/services.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../category/data/datasource/local/category_local_datasource.dart';
import '../../../category/data/model/local/category_local_model.dart';
import '../../../main_features/transactions/data/datasource/local/transactions_local_datasource.dart';
import '../../../main_features/transactions/data/datasource/sync/transaction_sync_store.dart';
import '../../../main_features/transactions/data/model/local/transaction_local_model.dart';
import '../../domain/repositories/transaction_sync_repository.dart';
import '../datasource/remote/sync_remote_datasource.dart';
import '../model/sync_delta_model.dart';

@LazySingleton(as: TransactionSyncRepository)
class TransactionSyncRepositoryImpl implements TransactionSyncRepository {
  final CategoryLocalDatasource _categoryLocalDatasource;
  final TransactionsLocalDatasource _transactionsLocalDatasource;
  final SyncRemoteDatasource _remoteSyncDatasource;
  final OnlineActionGuard _onlineActionGuard;
  final TransactionSyncStore _transactionSyncStore;

  TransactionSyncRepositoryImpl(
    this._categoryLocalDatasource,
    this._transactionsLocalDatasource,
    this._remoteSyncDatasource,
    this._onlineActionGuard,
    this._transactionSyncStore,
  );

  int limitCount = SizeAppUtils().isTablet ? 20 : 10;

  @override
  Future<Either<Failure, SyncDeltaModel>> loadTransactionDelta({
    String? lastTimeSync,
    required int page,
  }) async {
    // 1. Gọi Remote Datasource (API /sync_delta mới)
    final result = await _remoteSyncDatasource.getTransactionSyncDelta(
      lastTimeSync: lastTimeSync,
      page: page,
      limit: limitCount,
    );

    if (result.isFailure) return Left(ServerFailure(result.error!.message!));

    // 2. Parse data từ Response mới { data: [...], hasMore: bool, serverTime: string }
    final List<dynamic> rawList = result.data['data'] ?? [];
    final bool hasMore = result.data['hasMore'] ?? false;
    final String serverTime = result.data['serverTime'] ?? '';

    if (rawList.isEmpty) {
      return Right(
        SyncDeltaModel(data: [], hasMore: false, serverTime: serverTime),
      );
    }

    // 3. Xử lý Categories (vẫn giữ logic lưu kèm category)
    final categories = rawList
        .map((item) => item['category'])
        .whereType<Map<String, dynamic>>()
        .map<CategoryLocalModel>((json) => CategoryLocalModel.fromRemote(json))
        .toSet()
        .toList();

    if (categories.isNotEmpty) {
      await _categoryLocalDatasource.saveAll(categories);
    }

    // 4. Xử lý Transactions: Tách riêng danh sách Cập nhật và danh sách Xóa
    final List<TransactionLocalModel> toUpdate = [];
    final List<String> toDeleteServerIds = [];

    for (var item in rawList) {
      if (item['is_deleted'] == true) {
        toDeleteServerIds.add(item['id'].toString()); // Lưu ID server để xóa
      } else {
        toUpdate.add(TransactionLocalModel.fromRemote(item));
      }
    }

    // 5. Thực thi lưu/xóa vào Local Database (Isar)
    if (toDeleteServerIds.isNotEmpty) {
      await _transactionsLocalDatasource.deleteByServerIds(toDeleteServerIds);
    }
    if (toUpdate.isNotEmpty) {
      await _transactionsLocalDatasource.saveAll(toUpdate);
    }

    // 6. Xóa cache/store cũ nếu cần
    await _transactionSyncStore.clearAllSyncProgress();

    return Right(
      SyncDeltaModel(data: toUpdate, hasMore: hasMore, serverTime: serverTime),
    );
  }

  @override
  Future<({int notSynced, int total})> getTransactionSyncStatus() async {
    final total = await _transactionsLocalDatasource.getLengthData();
    final notSynced = await _transactionsLocalDatasource
        .getLengthDataNotYetSync();
    return (total: total, notSynced: notSynced);
  }

  @override
  Future<Either<Failure, int>> syncTransaction(int limitCount) async {
    Either<Failure, int> result = const Left(NetworkFailure("Not Internet"));

    await _onlineActionGuard.run((currentUserId, isConnected) async {
      try {
        final transactions = await _transactionsLocalDatasource
            .loadDataNotYetSync(limitCount);

        if (transactions.isEmpty) {
          result = const Right(0);
          return;
        }

        List<Uint8List> imageBuffers = [];
        List<Map<String, dynamic>> transactionsJson = [];
        List<String> imageNames = [];
        int currentFileIndex = 0;

        /// Create image fileIndex to mark which item has image
        for (var t in transactions) {
          var json = t.toJson();

          // If this transaction has image
          if (t.imageBytes != null && t.imageBytes!.isNotEmpty) {
            imageBuffers.add(Uint8List.fromList(t.imageBytes!));
            json['fileIndex'] = currentFileIndex;
            currentFileIndex++;
          }

          transactionsJson.add(json);
        }

        imageNames = transactions
            .where((t) => t.imageBytes != null)
            .map(
              (t) =>
                  "${currentUserId}_${DateTime.now().millisecondsSinceEpoch}.jpg",
            )
            .toList();

        final manifest = {'transactions': jsonEncode(transactionsJson)};

        final response = await _remoteSyncDatasource.syncTransaction(
          manifest,
          image_description_buffer_list: imageBuffers,
          image_name_list: imageNames,
        );

        if (response.isFailure) {
          result = Left(ServerFailure(response.error!.message ?? ''));
          return;
        }

        await _transactionsLocalDatasource.markAllAsSynced(
          transactions,
          currentUserId,
        );
        result = Right(transactions.length);
      } catch (e) {
        result = Left(ServerFailure(e.toString()));
      }
    });

    return result;
  }
}
