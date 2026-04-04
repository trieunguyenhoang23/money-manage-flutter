import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/core_external.dart';
import 'package:money_manage_flutter/features/main_features/transactions/data/datasource/sync/transaction_sync_store.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/datasource/local/category_local_datasource.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasource/local/transactions_local_datasource.dart';
import '../datasource/remote/transactions_remote_datasource.dart';
import '../datasource/sync/transaction_sync_key.dart';
import '../model/local/transaction_local_model.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionsRemoteDatasource _remoteDatasource;
  final TransactionsLocalDatasource _localDatasource;
  final SyncManager _syncManager;
  final TransactionSyncStore _syncStore;
  final CategoryLocalDatasource _categoryLocalDatasource;

  TransactionRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._syncManager,
    this._syncStore,
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

    // Reset sync key
    final syncKey = TransactionSyncKey(
      year: transactionAt.year,
      month: transactionAt.month,
      type: null, // Reset tab ALL
    );
    await _syncStore.reset(syncKey);

    return Right(transaction);
  }


  @override
  Future<List<TransactionLocalModel>> loadTransByMonth(
    int page,
    int month,
    int year, {
    TransactionType? type,
  }) async {
    /// Declare key for month & year
    final syncKey = TransactionSyncKey(year: year, month: month, type: type);

    // Fetch data from server first
    var localData = await _localDatasource.loadTransByMonth(
      page: page,
      month: month,
      year: year,
      type: type,
      limitCount: limitCount,
    );

    await _syncManager.runIfMeetStandard((
      currentActiveUserId,
      networkStatus,
    ) async {
      /// Check sync Status
      if (_syncStore.isFullyReachedEnd(syncKey)) return;

      /// Call API if the current page don't have enough data
      final progress = _syncStore.getProgress(syncKey);
      final bool isDataMissing = localData.length < limitCount;
      final bool isRequestingNewPage = page >= progress.nextPage;

      if (!isDataMissing && !isRequestingNewPage) return;

      /// Important:
      /// if missing data on the current page, reload that page
      /// if it's a completely new page, load the next page
      int pageToFetch = isDataMissing ? page : progress.nextPage;

      // Call API
      final result = await _remoteDatasource.loadTransByMonth(
        pageToFetch,
        limitCount,
        month,
        year,
        type: type?.name.toUpperCase(),
      );

      if (result.isFailure) return;

      if (result.data.isEmpty) {
        /// Mark data as expired for this month/year/type
        await _syncStore.markReachedEnd(syncKey);
        return;
      }

      // Save remote data to local
      final localModels = await parseListJsonIsolate(
        TransactionLocalModel.fromRemote,
        result.data,
      );

      /// Save category if needed
      final categories = result.data
          .map((item) => item['category'])
          .whereType<Map<String, dynamic>>()
          .map<CategoryLocalModel>(
            (json) => CategoryLocalModel.fromRemote(json),
          )
          .toSet() // Duplicate Filter (Unique)
          .toList();

      if (categories.isNotEmpty) {
        await _categoryLocalDatasource.saveAll(categories);
      }

      await _localDatasource.saveAll(localModels);

      // Update sync progress for this key was successful
      await _syncStore.savePage(syncKey, pageToFetch + 1);
    });

    // Fetch data from local again
    return await _localDatasource.loadTransByMonth(
      page: page,
      month: month,
      year: year,
      type: type,
      limitCount: limitCount,
    );
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
