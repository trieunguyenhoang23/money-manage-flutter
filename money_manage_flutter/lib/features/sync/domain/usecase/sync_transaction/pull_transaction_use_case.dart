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

  int limitCount = SizeAppUtils().isTablet ? 20 : 1;

  Stream<SyncBatchProgress> execute() async* {
    final schema = SyncSchema.transaction;
    String? lastSync = _syncLocalStorage.getLastSyncTime(schema);

    bool hasMore = true;
    int currentPage = 0;

    while (hasMore) {
      final pullResult = await _transactionSyncRepository.pullTransactionDelta(
        lastTimeSync: lastSync,
        page: currentPage,
        limitCount: limitCount,
      );

      final syncResponse = pullResult.fold(
        (failure) => throw failure,
        (response) => response,
      );

      hasMore = syncResponse.hasMore;

      // Don't know the total number of pages, gradually increase the progress bar but limit it to 0.95
      double pullProgress = 0.5 + (0.45 * (1 - (1 / (currentPage + 1))));
      // Reach to 1.0 when finish
      if (!hasMore) pullProgress = 1.0;

      yield SyncBatchProgress(
        type: SyncType.transaction,
        current: currentPage + 1,
        total: -1,
        overallProgress: pullProgress,
      );

      if (!hasMore) {
        await _updateSyncMetadata(schema, syncResponse.serverTime);
        await _transactionSyncStore.clearAllSyncProgress();
      }

      currentPage++;
    }
  }

  Future<void> _updateSyncMetadata(SyncSchema schema, String serverTime) async {
    await _syncLocalStorage.setLastSyncTime(schema, serverTime);
    await _syncLocalStorage.setFirstSyncCompleted(schema, true);
  }
}
