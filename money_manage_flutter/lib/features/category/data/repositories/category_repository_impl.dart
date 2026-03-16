import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../main_features/profile/data/datasource/local/user_local_datasource.dart';
import '../../../../core/enum/transaction_type.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasource/local/category_local_datasource.dart';
import '../datasource/remote/category_remote_datasource.dart';
import '../model/local/category_local_model.dart';
import '../model/remote/category_remote_model.dart';
import 'package:money_manage_flutter/export/core.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource _remoteDatasource;
  final CategoryLocalDatasource _localDatasource;
  final UserLocalDatasource _userLocalDatasource;
  final FlutterSecureStorage _secureStorage;

  CategoryRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._userLocalDatasource,
    this._secureStorage,
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
      bool isLogin = await _checkIsLogin();

      CategoryLocalModel categoryLocalModel = CategoryLocalModel.fromJson({
        'name': name,
        'description': desc,
        'type': type,
        'created_at': DateTime.now().toIso8601String(),
      });

      await _localDatasource.save(categoryLocalModel);

      // Upload data to server if isLogin = true
      if (isLogin) {
        await _remoteDatasource.uploadCategory(categoryLocalModel.toJson());
      }

      return Right(categoryLocalModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// GET
  @override
  Future<List<CategoryLocalModel>> loadCategoryByPage(int page) async {
    var localData = await _localDatasource.loadByPage(page, limitCount);

    if (await _checkIsLogin() && localData.isEmpty) {
      final remoteData = await _remoteDatasource.loadCateByPage(
        page,
        limitCount,
      );
      if (remoteData.isSuccess) {
        final localModels = await parseListJsonIsolate(
          CategoryLocalModel.fromJson,
          remoteData.data,
        );

        // Save to local Isar
        await _localDatasource.saveAll(localModels);
        localData = await _localDatasource.loadByPage(page, limitCount);
      }
    }

    return localData;
  }

  @override
  Future<List<CategoryLocalModel>> loadCategoryByType(
    int page,
    TransactionType type,
  ) async {
    var localData = await _localDatasource.loadByType(page, limitCount, type);

    if (await _checkIsLogin() && localData.isEmpty) {
      final remoteData = await _remoteDatasource.loadCateByPage(
        page,
        limitCount,
      );
      if (remoteData.isSuccess) {
        final localModels = await parseListJsonIsolate(
          CategoryLocalModel.fromJson,
          remoteData.data,
        );

        // Save to local Isar
        await _localDatasource.saveAll(localModels);
        localData = await _localDatasource.loadByType(page, limitCount, type);
      }
    }

    return localData;
  }

  /// PATCH
  @override
  Future<Either<Failure, CategoryLocalModel>> editCategory(
    String name,
    String desc,
    TransactionType type,
    CategoryLocalModel oldItem,
  ) async {
    try {
      oldItem
        ..name = name
        ..description = desc
        ..type = type
        ..updatedAt = DateTime.now();

      await _localDatasource.save(oldItem);

      ///Handle logic for server
      ///Parse data local
      if (await _checkIsLogin()) {
        await _remoteDatasource.updateCategory(
          oldItem.toJson(),
          id: oldItem.idServer,
        );
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

  Future<bool> _checkIsLogin() async {
    final bool availableAccessToken =
        (await _secureStorage.read(key: tokenKey)) != null;
    final bool availableLocalUser =
        (await _userLocalDatasource.getCurrentUser()) != null;
    return availableAccessToken && availableLocalUser;
  }
}
