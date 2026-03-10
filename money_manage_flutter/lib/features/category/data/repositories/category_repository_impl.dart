import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/core/error/failure.dart';
import '../../../main_features/transactions/domain/enums/transaction_type.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasource/local/category_local_datasource.dart';
import '../datasource/remote/category_remote_datasource.dart';
import '../model/local/category_local_model.dart';
import '../model/remote/category_remote_model.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRemoteDatasource _remoteDatasource;
  CategoryLocalDatasource _localDatasource;

  CategoryRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<Either<Failure, CategoryLocalModel>> createCategory(
    String name,
    String desc,
    TransactionType type,
  ) async {
    try {
      final token;
      final bool isLoggedIn = false;

      CategoryRemoteModel categoryRemoteModel = CategoryRemoteModel(
        name: name,
        description: desc,
        type: type,
      );
      CategoryLocalModel categoryLocalModel = categoryRemoteModel.toLocalModel(
        isSynced: isLoggedIn,
      );

      ///Handle logic for server

      await _localDatasource.save(categoryLocalModel);

      return Right(categoryLocalModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<List<CategoryLocalModel>> loadCategoryByPage(int page) async {
    return await _localDatasource.loadByPage(page);
  }

  @override
  Future<Either<Failure, CategoryLocalModel>> editCategory(
    String name,
    String desc,
    TransactionType type,
    CategoryLocalModel oldItem,
  ) async {
    try {
      final token;
      final bool isLoggedIn = false;

      oldItem
        ..name = name
        ..description = desc
        ..type = type
        ..updatedAt = DateTime.now();

      await _localDatasource.save(oldItem);

      ///Handle logic for server
      ///Parse data local
      oldItem.toJson('userId');

      return Right(oldItem);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
