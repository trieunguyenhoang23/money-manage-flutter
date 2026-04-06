import 'package:money_manage_flutter/export/core_external.dart';
import '../../../../core/utils/size_app_utils.dart';
import '../../data/datasource/local/sync_local_storage.dart';
import '../../data/model/sync_batch_progress.dart';
import '../repositories/transaction_sync_repository.dart';

@LazySingleton()
class SyncTransactionUseCase {
  final TransactionSyncRepository _transactionSyncRepository;
  final SyncLocalStorage _syncLocalStorage;

  SyncTransactionUseCase(
    this._transactionSyncRepository,
    this._syncLocalStorage,
  );

  int limitCount = SizeAppUtils().isTablet ? 20 : 10;

  Stream<SyncBatchProgress> execute() async* {
    final schema = SyncSchema.transaction;

    // =========================================================
    // Stage 1: PUSH LOCAL DATA TO SERVER(0.0 -> 0.5 overallProgress)
    // =========================================================
    final currentStatus = await _transactionSyncRepository
        .getTransactionSyncStatus();
    final int pushTotal = currentStatus.notSynced;
    int pushRemaining = pushTotal;

    if (pushTotal > 0) {
      while (pushRemaining > 0) {
        final result = await _transactionSyncRepository.syncTransaction(
          limitCount,
        );
        if (result.isLeft()) throw result.fold((l) => l, (r) => null)!;

        final newStatus = await _transactionSyncRepository
            .getTransactionSyncStatus();
        pushRemaining = newStatus.notSynced;

        // 0% - 50%
        double progress = ((pushTotal - pushRemaining) / pushTotal) * 0.5;

        yield SyncBatchProgress(
          type: SyncType.transaction,
          current: pushTotal - pushRemaining,
          total: pushTotal,
          overallProgress: progress,
        );
      }
    } else {
      // If there are nothing, finish the first progress
      yield SyncBatchProgress(
        type: SyncType.transaction,
        current: 0,
        total: 0,
        overallProgress: 0.5,
      );
    }

    // =========================================================
    // Stage 2: PULL SERVER TO LOCAL (0.5 -> 1.0 overallProgress)
    // =========================================================

    String? lastSync = _syncLocalStorage.getLastSyncTime(schema);
    bool hasMore = true;
    int currentPage = 0;

    while (hasMore) {
      final pullResult = await _transactionSyncRepository.loadTransactionDelta(
        lastTimeSync: lastSync,
        page: currentPage,
      );

      final syncResponse = pullResult.fold(
        (failure) => throw failure,
        (response) => response,
      );

      hasMore = syncResponse.hasMore;

      double pullProgress =
          0.5 +
          (0.5 * (hasMore ? (currentPage / (currentPage + 1)) * 0.9 : 1.0));

      yield SyncBatchProgress(
        type: SyncType.transaction,
        current: currentPage,
        total: -1,
        overallProgress: pullProgress,
      );

      currentPage++;

      if (!hasMore) {
        await _syncLocalStorage.setLastSyncTime(
          schema,
          syncResponse.serverTime,
        );
        await _syncLocalStorage.setFirstSyncCompleted(schema, true);
      }
    }

    yield SyncBatchProgress(
      type: SyncType.transaction,
      current: 100,
      total: 100,
      overallProgress: 1.0,
    );
  }
}
