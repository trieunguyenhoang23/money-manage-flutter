import 'package:money_manage_flutter/export/core_external.dart';
import '../../../../../core/utils/size_app_utils.dart';
import '../../../../main_features/transactions/data/datasource/sync/transaction_sync_store.dart';
import '../../../data/datasource/local/sync_local_storage.dart';
import '../../../data/model/sync_batch_progress.dart';
import '../../repositories/transaction_sync_repository.dart';

@LazySingleton()
class PullTransactionUseCase {
  final TransactionSyncRepository _transactionSyncRepository;
  final SyncLocalStorage _syncLocalStorage;
  final TransactionSyncStore _transactionSyncStore;

  PullTransactionUseCase(
    this._transactionSyncRepository,
    this._syncLocalStorage,
    this._transactionSyncStore,
  );

  int get _limit => SizeAppUtils().isTablet ? 20 : 10;

  Stream<SyncBatchProgress> execute() async* {
    final schema = SyncSchema.transaction;
    String? lastSync = _syncLocalStorage.getLastSyncTime(schema);

    bool hasMore = true;
    int currentPage = 0;

    while (hasMore) {
      final result = await _transactionSyncRepository.pullTransactionDelta(
        lastTimeSync: lastSync,
        page: currentPage,
        limitCount: _limit,
      );

      final response = result.fold(
        (failure) => throw failure,
        (success) => success,
      );

      hasMore = response.hasMore;
      double progress = _calculateProgress(currentPage, hasMore);

      if (!hasMore) {
        await _updateSyncMetadata(schema, response.serverTime);
      }

      yield SyncBatchProgress(
        type: SyncType.transaction,
        current: currentPage + 1,
        total: -1, // Don't know exact page
        overallProgress: progress,
      );

      currentPage++;
    }
  }

  double _calculateProgress(int page, bool hasMore) {
    if (!hasMore) return 1.0;
    return 0.5 + (0.45 * (1 - (1 / (page + 1))));
  }

  Future<void> _updateSyncMetadata(SyncSchema schema, String serverTime) async {
    await _syncLocalStorage.setLastSyncTime(schema, serverTime);
    await _syncLocalStorage.setFirstSyncCompleted(schema, true);
    await _transactionSyncStore.clearAllSyncProgress();
  }
}
