import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../datasource/sync/category_sync_store.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasource/local/category_local_datasource.dart';
import '../datasource/remote/category_remote_datasource.dart';
import '../model/local/category_local_model.dart';
import 'package:money_manage_flutter/export/core.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource _remoteDatasource;
  final CategoryLocalDatasource _localDatasource;
  final SyncManager _syncManager;
  final CategorySyncStore _categorySyncStore;

  CategoryRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._syncManager,
    this._categorySyncStore,
  );

  int limitCount = SizeAppUtils().isTablet ? 20 : 10;

  /// CRUD
  ///POST
  @override
  Future<Either<Failure, CategoryLocalModel>> createCategory(
    String name,
    String desc,
    TransactionType type,
  ) async {
    try {
      CategoryLocalModel categoryLocalModel = CategoryLocalModel(
        name: name,
        description: desc,
        type: type,
        createdAt: DateTime.now(),
      );

      // Upload data to server if isLogin = true
      await _syncManager.runIfMeetStandard((
        currentActiveUserId,
        networkStatus,
      ) async {
        await _remoteDatasource
            .uploadCategory(categoryLocalModel.toJson())
            .then((result) {
              if (result.isSuccess) {
                categoryLocalModel
                  ..isSynced = true
                  ..userId = currentActiveUserId;
              }
            });
      });

      await _localDatasource.save(categoryLocalModel);

      return Right(categoryLocalModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// GET
  @override
  Future<List<CategoryLocalModel>> loadCategoryByPage(int page) async {
    var localData = await _localDatasource.loadByPage(page, limitCount);

    await _syncManager.runIfMeetStandard((
      currentActiveUserId,
      networkStatus,
    ) async {
      if (_categorySyncStore.hasReachedEnd()) return;

      bool isPartialPage = localData.length < limitCount;

      /// If local data in this page doesn't meet limitCount
      if (isPartialPage) {
        /// Get last page to continue fetching dat from server
        int lastFetched = _categorySyncStore.getLastPage();
        int nextPage = lastFetched + 1;

        await _remoteDatasource.loadCateByPage(page, limitCount).then((
          result,
        ) async {
          if (result.isFailure) return;

          /// Set last page if data is empty
          if (result.data.isEmpty) {
            await _categorySyncStore.setReachedEnd(true);
            return;
          }

          /// Save lastest fetching page
          await _categorySyncStore.setLastPage(nextPage);
          final localModels = await parseListJsonIsolate(
            CategoryLocalModel.fromRemote,
            result.data,
          );

          // Save to local Isar
          await _localDatasource.saveAll(localModels);
          // Re-fetch from local to get the unified list
          localData = await _localDatasource.loadByPage(page, limitCount);
        });
      }
    });

    return localData;
  }

  @override
  Future<List<CategoryLocalModel>> loadCategoryByType(
    int page,
    TransactionType type,
  ) async {
    var localData = await _localDatasource.loadByType(page, limitCount, type);

    await _syncManager.runIfMeetStandard((
      currentActiveUserId,
      networkStatus,
    ) async {
      bool isPartialPage = localData.length < limitCount;
      if (isPartialPage) {
        // Fetch data from server
        await _remoteDatasource.loadCateByPage(page, limitCount).then((
          result,
        ) async {
          if (result.isFailure) return;

          final localModels = await parseListJsonIsolate(
            CategoryLocalModel.fromRemote,
            result.data,
          );

          // Save to local Isar
          await _localDatasource.saveAll(localModels);
          localData = await _localDatasource.loadByType(page, limitCount, type);
        });
      }
    });

    return localData;
  }

  /// PATCH
  @override
  Future<Either<Failure, CategoryLocalModel>> editCategory(
    Map<String, dynamic> updatedJson,
    CategoryLocalModel oldItem,
  ) async {
    try {
      bool hasChanged = oldItem.merge(
        newName: updatedJson['name'],
        newDescription: updatedJson['description'],
        newType: updatedJson['type'] != null
            ? TransactionType.fromDynamic(updatedJson['type'])
            : null,
      );

      /// Just update if any properties change
      if (hasChanged) {
        await _syncManager.runIfMeetStandard((
          currentActiveUserId,
          networkStatus,
        ) async {
          await _remoteDatasource
              .updateCategory(updatedJson, id: oldItem.idServer!)
              .then((result) {
                oldItem
                  ..userId = currentActiveUserId
                  ..isSynced = true;
              });
        });
        await _localDatasource.save(oldItem);
      }

      return Right(oldItem);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> clearAllData() async {
    await _localDatasource.clearAll();
  }
}
