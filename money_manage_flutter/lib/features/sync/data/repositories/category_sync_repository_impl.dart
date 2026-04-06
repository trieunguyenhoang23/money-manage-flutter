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

  int limitCount = SizeAppUtils().isTablet ? 20 : 10;

  @override
  Future<Either<Failure, SyncDeltaModel>> loadCateDelta({
    String? lastTimeSync,
    int page = 0,
  }) async {
    // 1. Gọi Remote API
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

    // 2. Parse wrapper data
    final List<dynamic> rawList = result.data['data'] ?? [];
    final bool hasMore = result.data['hasMore'] ?? false;
    final String serverTime = result.data['serverTime'] ?? '';

    if (rawList.isEmpty) {
      return Right(
        SyncDeltaModel(data: [], hasMore: false, serverTime: serverTime),
      );
    }

    // 3. Chuyển đổi sang Local Model
    final remoteData = await parseListJsonIsolate(
      CategoryLocalModel.fromRemote,
      rawList,
    );

    // 4. Lưu vào Local (Chỉ cần saveAll vì không có logic xóa)
    // Isar .putAll sẽ tự cập nhật các bản ghi cũ dựa trên ID
    await _categoryLocalDatasource.saveAll(remoteData);

    return Right(
      SyncDeltaModel(
        data: remoteData,
        hasMore: hasMore,
        serverTime: serverTime,
      ),
    );
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
