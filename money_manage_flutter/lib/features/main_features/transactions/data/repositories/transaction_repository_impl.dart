import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../../../export/core_external.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../../../sync/domain/service/transaction/transaction_pull_service.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasource/local/transactions_local_datasource.dart';
import '../datasource/remote/transactions_remote_datasource.dart';
import '../model/local/transaction_local_model.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionsRemoteDatasource _remoteDatasource;
  final TransactionsLocalDatasource _localDatasource;
  final OnlineActionGuard _onlineActionGuard;
  final TransactionPullService _transactionPullService;

  TransactionRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._onlineActionGuard,
    this._transactionPullService,
  );

  @override
  Future<List<CategoryLocalModel>> getCategoryThroughTrans(
    TransactionType type,
    int range,
  ) async {
    return await _localDatasource.getRecentActiveCategories(range, type);
  }

  @override
  Future<Either<Failure, TransactionLocalModel>> addTransaction({
    required TransactionLocalModel transaction,
    required CategoryLocalModel category,
    FilePicked? imageFile,
  }) async {
    // Add more properties if logged in
    await _onlineActionGuard.run((currentActiveUserId, networkStatus) async {
      // Upload Transaction to Server
      final result = await _remoteDatasource.uploadTransaction(
        transaction.toJson(),
        image_description_buffer: imageFile?.bytes,
        image_name:
            '${currentActiveUserId}_${DateTime.now().millisecondsSinceEpoch}.${imageFile?.extension}',
      );

      if (result.isSuccess) {
        transaction
          ..imageUrl = result.data['image_description']
          ..imageBytes = null
          ..userId = currentActiveUserId
          ..isSynced = true;
      }
    });

    await _localDatasource.putTransaction(transaction, category);

    return Right(transaction);
  }

  @override
  Future<List<TransactionLocalModel>> getLocalTransactions({
    required int page,
    required int month,
    required int year,
    TransactionType? type,
    required int limit,
  }) {
    return _localDatasource.loadTransByMonth(
      page: page,
      month: month,
      year: year,
      type: type,
      limitCount: limit,
    );
  }

  @override
  Future<Either<Failure, List<TransactionLocalModel>>>
  fetchAndSaveRemoteTransactions({
    required int page,
    required int month,
    required int year,
    TransactionType? type,
    required int limit,
  }) async {
    final result = await _remoteDatasource.loadTransByMonth(
      page,
      limit,
      month,
      year,
      type: type?.name.toUpperCase(),
    );

    if (result.isFailure) {
      return Left(ServerFailure(result.error?.message ?? ''));
    }

    final localModels = await parseListJsonIsolate(
      TransactionLocalModel.fromRemote,
      result.data,
    );

    await _transactionPullService.saveCategoryIfNeeded(result.data);
    await _localDatasource.saveAll(localModels);

    return Right(localModels);
  }

  @override
  Future<Either<Failure, bool>> removeTransaction({
    required TransactionLocalModel transaction,
  }) async {
    bool syncResult = true;
    String? error;
    await _onlineActionGuard.run((currentActiveUserId, networkStatus) async {
      if (transaction.idServer == null) {
        syncResult = false;
        return;
      }

      final result = await _remoteDatasource.removeTransaction(
        transaction.idServer ?? '',
      );

      if (result.isFailure) {
        syncResult = false;
        error = result.error?.message;
        return;
      }
      syncResult = true;
    });

    if (syncResult) {
      await _localDatasource.removeTransaction(transaction);
      return const Right(true);
    }

    return Left(ServerFailure(error ?? ''));
  }


  @override
  Future<Either<Failure, TransactionLocalModel>> updateTransaction({
    required Map<String, dynamic> updateJsonRequestBody,
    required TransactionLocalModel oldItem,
    required CategoryLocalModel newCate,
    required bool isDeleteImg,
    FilePicked? imageFile,
  }) async {
    await _onlineActionGuard.run((currentActiveUserId, networkStatus) async {
      // Update Transaction to Server
      final result = await _remoteDatasource.updateTransaction(
        id: oldItem.idServer ?? '',
        updateJsonRequestBody,
        image_description_buffer: imageFile?.bytes,
        image_name:
            '${currentActiveUserId}_${DateTime.now().millisecondsSinceEpoch}.${imageFile?.extension}',
      );

      if (result.isFailure) return;

      String? imgUrlTemp = isDeleteImg
          ? null
          : result.data['image_description'] ?? oldItem.imageUrl;

      oldItem
        ..imageUrl = imgUrlTemp
        ..imageBytes = null
        ..userId = currentActiveUserId
        ..isSynced = true;
    });
    await _localDatasource.putTransaction(oldItem, newCate);

    return Right(oldItem);
  }

  @override
  Future<void> clearAllData() async {
    await _localDatasource.clearAll();
  }
}
