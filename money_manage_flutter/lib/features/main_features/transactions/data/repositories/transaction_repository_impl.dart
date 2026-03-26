import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/core_external.dart';
import '../../../../../core/data/datasource/sync_state_datasource.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/datasource/local/category_local_datasource.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasource/local/transactions_local_datasource.dart';
import '../datasource/remote/transactions_remote_datasource.dart';
import '../model/local/transaction_local_model.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionsRemoteDatasource _remoteDatasource;
  final TransactionsLocalDatasource _localDatasource;
  final SyncManager _syncManager;
  final SyncStateDatasource _syncStateDatasource;
  final CategoryLocalDatasource _categoryLocalDatasource;

  TransactionRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._syncManager,
    this._syncStateDatasource,
    this._categoryLocalDatasource,
  );

  int limitCount = SizeAppUtils().isTablet ? 20 : 10;

  @override
  Future<List<CategoryLocalModel>> getCategoryThroughTrans(
    TransactionType type,
    int range,
  ) async {
    return await _localDatasource.getRecentActiveCategories(range, type);
  }

  @override
  Future<Either<Failure, TransactionLocalModel>> addTransaction({
    required double amount,
    required String note,
    required CategoryLocalModel category,
    required DateTime transactionAt,
    FilePicked? imageFile,
  }) async {
    final now = DateTime.now();

    TransactionLocalModel transaction = TransactionLocalModel(
      amount: amount,
      note: note,
      type: category.type ?? TransactionType.EXPENSE,
      categoryId: category.idServer!,
      transactionAt: transactionAt,
      createdAt: now,
      updatedAt: now,
      imageBytes: imageFile?.bytes,
      isSynced: false,
    );

    // Add more properties if logged in
    await _syncManager.runIfMeetStandard((
      currentActiveUserId,
      networkStatus,
    ) async {
      String imageName =
          '${currentActiveUserId}_${DateTime.now().millisecondsSinceEpoch}.${imageFile?.extension}';
      // Upload Transaction to Server
      final result = await _remoteDatasource.uploadTransaction(
        transaction.toJson(),
        image_description_buffer: imageFile?.bytes,
        image_name: imageName,
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
  Future<List<TransactionLocalModel>> loadTransByPage(int page) async {
    var localData = await _localDatasource.loadByPage(page, limitCount);

    await _syncManager.runIfMeetStandard((
      currentActiveUserId,
      networkStatus,
    ) async {
      if (_syncStateDatasource.hasReachedEnd(SyncSchema.transaction)) return;

      bool isPartialPage = localData.length < limitCount;

      /// If local data in this page doesn't meet limitCount
      if (isPartialPage) {
        /// Get last page to continue fetching dat from server
        int lastFetched = _syncStateDatasource.getLastPage(
          SyncSchema.transaction,
        );
        int nextPage = lastFetched + 1;

        await _remoteDatasource.loadTransByPage(page, limitCount).then((
          result,
        ) async {
          if (result.isFailure) return;

          /// Set last page if data is empty
          if (result.data.isEmpty) {
            await _syncStateDatasource.setReachedEnd(
              SyncSchema.transaction,
              true,
            );
            return;
          }

          /// Save lastest fetching page
          await _syncStateDatasource.setLastPage(
            SyncSchema.transaction,
            nextPage,
          );

          final localModels = await parseListJsonIsolate(
            TransactionLocalModel.fromRemote,
            result.data,
          );

          // Save category to local
          for (var item in result.data) {
            final localCategory = CategoryLocalModel.fromRemote(
              item['category'],
            );
            await _categoryLocalDatasource.save(localCategory);
          }

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
  Future<Either<Failure, bool>> removeTransaction({
    required TransactionLocalModel transaction,
  }) async {
    dynamic syncResult = true;
    await _syncManager.runIfMeetStandard((
      currentActiveUserId,
      networkStatus,
    ) async {
      if (transaction.idServer == null) {
        syncResult = false;
        return;
      }

      await _remoteDatasource.removeTransaction(transaction.idServer!).then((
        result,
      ) {
        if (result.isFailure) {
          syncResult = Fail(result);
          return;
        }
        syncResult = true;
      });
    });

    if (syncResult) {
      await _localDatasource.removeTransaction(transaction);
    }
    return Right(syncResult);
  }

  @override
  Future<Either<Failure, TransactionLocalModel>> updateTransaction({
    required Map<String, dynamic> updateJsonRequestBody,
    required TransactionLocalModel oldItem,
    required CategoryLocalModel newCate,
    FilePicked? imageFile,
  }) async {
    bool hasChanged = oldItem.merge(
      amountTemp: updateJsonRequestBody['amount'] ?? oldItem.amount,
      noteTemp: updateJsonRequestBody['note'] ?? oldItem.note,
      transactionAtTemp: updateJsonRequestBody['transaction_at'] != null
          ? DateTime.parse(updateJsonRequestBody['transaction_at'])
          : oldItem.transactionAt,
      cateTemp: newCate,
      newImageBytes: imageFile?.bytes,
    );

    /// Just update if any data change
    if (hasChanged) {
      await _syncManager.runIfMeetStandard((
        currentActiveUserId,
        networkStatus,
      ) async {
        String imageName =
            '${currentActiveUserId}_${DateTime.now().millisecondsSinceEpoch}.${imageFile?.extension}';

        // Update Transaction to Server
        await _remoteDatasource
            .updateTransaction(
              id: oldItem.idServer ?? '',
              updateJsonRequestBody,
              image_description_buffer: imageFile?.bytes,
              image_name: imageName,
            )
            .then((result) async {
              if (result.isFailure) return;
              oldItem
                ..imageUrl =
                    result.data['image_description'] ?? oldItem.imageUrl
                ..imageBytes = null
                ..userId = currentActiveUserId
                ..isSynced = true;
            });
      });
      await _localDatasource.putTransaction(oldItem, newCate);
    }

    return Right(oldItem);
  }

  @override
  Future<void> clearAllData() async {
    await _localDatasource.clearAll();
  }
}
