import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../category/data/datasource/local/category_local_datasource.dart';
import '../../../category/data/model/local/category_local_model.dart';
import '../../domain/repositories/category_sync_repository.dart';
import '../datasource/remote/sync_remote_datasource.dart';
import '../model/sync_delta_model.dart';

@LazySingleton(as: CategorySyncRepository)
class CategorySyncRepositoryImpl implements CategorySyncRepository {
  final CategoryLocalDatasource _categoryLocalDatasource;
  final SyncRemoteDatasource _syncRemoteDatasource;
  final OnlineActionGuard _onlineActionGuard;

  CategorySyncRepositoryImpl(
    this._categoryLocalDatasource,
    this._syncRemoteDatasource,
    this._onlineActionGuard,
  );

  @override
  Future<Either<Failure, SyncDeltaModel>> pullCategoryDelta({
    String? lastTimeSync,
    required int page,
    required int limitCount,
  }) async {
    final result = await _syncRemoteDatasource.getCategorySyncDelta(
      lastTimeSync: lastTimeSync,
      page: page,
      limit: limitCount,
    );

    if (result.isFailure) {
      return Left(
        ServerFailure(result.error?.message ?? "Load categories failed"),
      );
    }

    final SyncDeltaModel syncDelta = SyncDeltaModel.fromJson(result.data);

    if (syncDelta.data.isEmpty) {
      return Right(syncDelta);
    }

    // Parse data
    final remoteData = await parseListJsonIsolate(
      CategoryLocalModel.fromRemote,
      syncDelta.data,
    );

    // Save to local
    await _categoryLocalDatasource.saveAll(remoteData);

    return Right(syncDelta);
  }

  @override
  Future<({int total, int notSynced})> getCategorySyncStatus() async {
    final total = await _categoryLocalDatasource.getLengthData();
    final notSynced = await _categoryLocalDatasource.getLengthDataNotYetSync();
    return (total: total, notSynced: notSynced);
  }

  @override
  Future<Either<Failure, int>> pushCategoryDelta(int limitCount) async {
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

        // Create payload Json
        final manifest = {
          'categories': categories.map((e) => e.toJson()).toList(),
        };

        final response = await _syncRemoteDatasource.syncCategoryData(manifest);

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
}