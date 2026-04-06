import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/services.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/features/category/data/datasource/remote/category_remote_datasource.dart';
import '../../../category/data/datasource/local/category_local_datasource.dart';
import '../../../category/data/model/local/category_local_model.dart';
import '../../../main_features/transactions/data/datasource/local/transactions_local_datasource.dart';
import '../../../main_features/transactions/data/datasource/remote/transactions_remote_datasource.dart';
import '../../../main_features/transactions/data/datasource/sync/transaction_sync_store.dart';
import '../../../main_features/transactions/data/model/local/transaction_local_model.dart';
import '../../domain/repositories/sync_repository.dart';
import '../datasource/local/sync_local_storage.dart';
import '../datasource/remote/sync_remote_datasource.dart';

@LazySingleton(as: SyncRepository)
class SyncRepositoryImpl implements SyncRepository {
  final CategoryRemoteDatasource _categoryRemoteDatasource;
  final CategoryLocalDatasource _categoryLocalDatasource;
  final TransactionsLocalDatasource _transactionsLocalDatasource;
  final TransactionsRemoteDatasource _transactionsRemoteDatasource;
  final SyncRemoteDatasource _remoteSyncDatasource;
  final OnlineActionGuard _onlineActionGuard;
  final SyncLocalStorage _syncLocalStorage;
  final TransactionSyncStore _transactionSyncStore;

  SyncRepositoryImpl(
    this._categoryRemoteDatasource,
    this._categoryLocalDatasource,
    this._transactionsLocalDatasource,
    this._remoteSyncDatasource,
    this._onlineActionGuard,
    this._syncLocalStorage,
    this._transactionsRemoteDatasource,
    this._transactionSyncStore,
  );

  int limitCount = SizeAppUtils().isTablet ? 20 : 10;

  @override
  Future<Either<Failure, bool>> loadCateByPageFromServer() async {
    final schema = SyncSchema.category;
    int currentPage = _syncLocalStorage.getLastPage(schema);
    final result = await _categoryRemoteDatasource.loadCateByPage(
      currentPage,
      limitCount,
    );
    if (result.isFailure) {
      return Left(
        ServerFailure(result.error?.message ?? "Load categories failed"),
      );
    }

    if (result.data.isEmpty) {
      await _syncLocalStorage.setReachedEnd(schema, true);
      return const Right(
        false,
      ); // Trả về false để dừng vòng lặp while trong UseCase
    }

    final remoteData = await parseListJsonIsolate(
      CategoryLocalModel.fromRemote,
      result.data,
    );

    await _categoryLocalDatasource.saveAll(remoteData);

    await _syncLocalStorage.setLastPage(schema, currentPage + 1);
    return const Right(true);
  }

  @override
  Future<({int total, int notSynced})> getCategorySyncStatus() async {
    final total = await _categoryLocalDatasource.getLengthData();
    final notSynced = await _categoryLocalDatasource.getLengthDataNotYetSync();
    return (total: total, notSynced: notSynced);
  }

  @override
  Future<Either<Failure, int>> syncCategory(int limitCount) async {
    Either<Failure, int> result = const Left(NetworkFailure("Not Internet"));

    await _onlineActionGuard.run((currentUserId, isConnected) async {
      try {
        final categories = await _categoryLocalDatasource.loadDataNotYetSync(
          limitCount,
        );

        if (categories.isEmpty) {
          result = const Right(0);
          return;
        }

        final manifest = {
          'categories': categories.map((e) => e.toJson()).toList(),
        };

        final response = await _remoteSyncDatasource.syncCategoryData(manifest);

        if (response.isFailure) {
          result = Left(ServerFailure(response.error!.message ?? ''));
          return;
        }

        /// Mark local data as synced
        await _categoryLocalDatasource.markAllAsSynced(
          categories,
          currentUserId,
        );
        result = Right(categories.length);
      } catch (e) {
        result = Left(ServerFailure(e.toString()));
      }
    });

    return result;
  }

  /// -------------------------- TRANSACTION --------------------------
  @override
  Future<Either<Failure, bool>> loadTransByPageFromServer() async {
    final schema = SyncSchema.transaction;

    /// Get last page to continue fetching dat from server
    int currentPage = _syncLocalStorage.getLastPage(schema);

    final result = await _transactionsRemoteDatasource.loadTransByPage(
      currentPage,
      limitCount,
    );
    if (result.isFailure) return Left(ServerFailure(result.error!.message!));

    if (result.data.isEmpty) {
      await _syncLocalStorage.setReachedEnd(schema, true);
      return const Right(false);
    }

    final remoteData = await parseListJsonIsolate(
      TransactionLocalModel.fromRemote,
      result.data,
    );

    // Save category to local
    final categories = result.data
        .map((item) => item['category'])
        .whereType<Map<String, dynamic>>()
        .map<CategoryLocalModel>((json) => CategoryLocalModel.fromRemote(json))
        .toSet() // Duplicate Filter (Unique)
        .toList();

    if (categories.isNotEmpty) {
      await _categoryLocalDatasource.saveAll(categories);
    }

    await _transactionsLocalDatasource.saveAll(remoteData);
    await _syncLocalStorage.setLastPage(schema, currentPage + 1);

    /// Reset loading transaction by by month, year
    await _transactionSyncStore.clearAllSyncProgress();
    return const Right(true);
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
