import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasource/local/category_local_datasource.dart';
import '../datasource/remote/category_remote_datasource.dart';
import '../model/local/category_local_model.dart';
import 'package:money_manage_flutter/export/core.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource _remoteDatasource;
  final CategoryLocalDatasource _localDatasource;
  final OnlineActionGuard _onlineActionGuard;

  CategoryRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._onlineActionGuard,
  );

  /// CRUD
  ///POST
  @override
  Future<Either<Failure, CategoryLocalModel>> createCategory(
    CategoryLocalModel categoryLocalModel,
  ) async {
    try {
      // Upload data to server if isLogin = true
      await _onlineActionGuard.run((currentActiveUserId, networkStatus) async {
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
  Future<List<CategoryLocalModel>> loadCategoryByPage(
    int page,
    int limitCount,
    bool isSynced,
  ) async {
    var localData = await _localDatasource.loadByPage(page, limitCount);

    if (!isSynced && localData.length < limitCount) {
      await _onlineActionGuard.run((currentActiveUserId, networkStatus) async {
        final result = await _remoteDatasource.loadCateByPage(page, limitCount);

        if (result.isSuccess && result.data.isNotEmpty) {
          final remoteModels = await parseListJsonIsolate(
            CategoryLocalModel.fromRemote,
            result.data,
          );

          await _localDatasource.saveAll(remoteModels);
          localData = await _localDatasource.loadByPage(page, limitCount);
        }
      });
    }

    return localData;
  }

  /// PATCH
  @override
  Future<Either<Failure, CategoryLocalModel>> editCategory(
    Map<String, dynamic> updatedJson,
    CategoryLocalModel oldItem,
    bool hasChanged,
  ) async {
    try {
      /// Just update if any properties change
      if (hasChanged) {
        await _onlineActionGuard.run((
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
