import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/services.dart';
import 'package:money_manage_flutter/core/network/sync_manager.dart';
import '../../../../core/error/failure.dart';
import '../../../category/data/datasource/local/category_local_datasource.dart';
import '../../../main_features/transactions/data/datasource/local/transactions_local_datasource.dart';
import '../../domain/repositories/sync_repository.dart';
import '../datasource/remote/sync_remote_datasource.dart';

@LazySingleton(as: SyncRepository)
class SyncRepositoryImpl implements SyncRepository {
  final CategoryLocalDatasource _categoryLocalDatasource;
  final TransactionsLocalDatasource _transactionsLocalDatasource;
  final SyncRemoteDatasource _remoteSyncDatasource;
  final SyncManager _syncManager;

  SyncRepositoryImpl(
    this._categoryLocalDatasource,
    this._transactionsLocalDatasource,
    this._remoteSyncDatasource,
    this._syncManager,
  );

  @override
  Future<({int total, int notSynced})> getCategorySyncStatus() async {
    final total = await _categoryLocalDatasource.getLengthData();
    final notSynced = await _categoryLocalDatasource.getLengthDataNotYetSync();
    return (total: total, notSynced: notSynced);
  }

  @override
  Future<Either<Failure, int>> syncCategory(int limitCount) async {
    Either<Failure, int> result = const Left(NetworkFailure("Not Internet"));

    await _syncManager.runIfMeetStandard((currentUserId, isConnected) async {
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

    await _syncManager.runIfMeetStandard((currentUserId, isConnected) async {
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
