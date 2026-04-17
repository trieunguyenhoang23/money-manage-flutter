import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../data/datasource/sync/transaction_sync_key.dart';
import '../../data/datasource/sync/transaction_sync_store.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../repositories/transaction_repository.dart';

@LazySingleton()
class LoadingTransactionUseCase {
  final TransactionRepository _repository;
  final TransactionSyncStore _transactionSyncStore;
  final OnlineActionGuard _onlineActionGuard;

  LoadingTransactionUseCase(
    this._repository,
    this._transactionSyncStore,
    this._onlineActionGuard,
  );

  int get _limit => SizeAppUtils().isTablet ? 20 : 10;

  Future<List<TransactionLocalModel>> execute(
    int page,
    int month,
    int year, {
    TransactionType? type,
  }) async {
    final syncKey = TransactionSyncKey(year: year, month: month, type: type);

    await _onlineActionGuard.run((userId, status) async {
      /// Check sync Status
      if (_shouldSkipSync(syncKey)) return;
      final progress = _transactionSyncStore.getProgress(syncKey);

      // Fetch data from local first
      var data = await _repository.getLocalTransactions(
        page: page,
        month: month,
        year: year,
        type: type,
        limit: _limit,
      );

      final bool isDataMissing = data.length < _limit;
      final bool isRequestingNewPage = page >= progress.nextPage;

      if (!isDataMissing && !isRequestingNewPage) return;

      /// Important:
      /// if missing data on the current page, reload that page
      /// if it's a completely new page, load the next page
      int pageToFetch = isDataMissing ? page : progress.nextPage;

      // Call API
      final result = await _repository.fetchAndSaveRemoteTransactions(
        page: pageToFetch,
        month: month,
        year: year,
        type: type,
        limit: _limit,
      );

      result.fold(
        (l) => null, // Handle error
        (remoteData) async {
          if (remoteData.isEmpty ||
              /// remoteData.length < _limit => This is the last page
              (remoteData.length < _limit)) {
            await _markEndEffectively(syncKey);

            return;
          }
          await _transactionSyncStore.saveProgress(
            syncKey,
            page: pageToFetch + 1,
          );
        },
      );
    });

    // Fetch data from local again
    return await _repository.getLocalTransactions(
      page: page,
      month: month,
      year: year,
      type: type,
      limit: _limit,
    );
  }

  bool _shouldSkipSync(TransactionSyncKey key) {
    final current = _transactionSyncStore.getProgress(key);
    if (current.hasReachedEnd) return true;

    if (key.type != null) {
      final allKey = TransactionSyncKey(
        year: key.year,
        month: key.month,
        type: null,
      );
      if (_transactionSyncStore.getProgress(allKey).hasReachedEnd) return true;
    }
    return false;
  }

  Future<void> _markEndEffectively(TransactionSyncKey key) async {
    await _transactionSyncStore.saveProgress(key, end: true);
    // If the All type runs out of data ->  Income & Expense will run out too
    if (key.type == null) {
      await _transactionSyncStore.saveProgress(
        key.copyWith(type: TransactionType.INCOME),
        end: true,
      );
      await _transactionSyncStore.saveProgress(
        key.copyWith(type: TransactionType.EXPENSE),
        end: true,
      );
    }
  }
}
