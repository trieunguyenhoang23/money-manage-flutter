import 'package:money_manage_flutter/export/core_external.dart';
import '../../data/datasource/local/sync_local_storage.dart';
import '../../data/model/sync_batch_progress.dart';
import '../repositories/sync_repository.dart';

@LazySingleton()
class SyncTransactionUseCase {
  final SyncRepository _syncRepository;
  final SyncLocalStorage _syncLocalStorage;

  SyncTransactionUseCase(this._syncRepository, this._syncLocalStorage);

  static const limitCount = 20;

  Stream<SyncBatchProgress> execute() async* {
    final schema = SyncSchema.transaction;

    // =========================================================
    // Stage 1: PUSH LOCAL DATA TO SERVER(0.0 -> 0.5 overallProgress)
    // =========================================================
    final currentStatus = await _syncRepository.getTransactionSyncStatus();
    final int pushTotal = currentStatus.notSynced;
    int pushRemaining = pushTotal;

    if (pushTotal > 0) {
      while (pushRemaining > 0) {
        final result = await _syncRepository.syncTransaction(limitCount);
        if (result.isLeft()) throw result.fold((l) => l, (r) => null)!;

        final newStatus = await _syncRepository.getTransactionSyncStatus();
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

    if (_syncLocalStorage.hasReachedEnd(schema)) {
      yield SyncBatchProgress(
        type: SyncType.transaction,
        current: 100,
        total: 100,
        overallProgress: 1.0,
      );
      return;
    }

    bool hasMore = true;
    while (hasMore) {
      final pullResult = await _syncRepository.loadTransByPageFromServer();

      if (pullResult.isLeft()) {
        throw pullResult.fold((l) => l, (r) => null)!;
      }

      hasMore = pullResult.getOrElse(() => false);

      // Use page to load progress because don't determine the total of transaction
      // 0.5 -> 1
      int currentPage = _syncLocalStorage.getLastPage(schema);
      double pullProgress =
          0.5 +
          (0.5 * (hasMore ? (currentPage / (currentPage + 1)) * 0.9 : 1.0));

      yield SyncBatchProgress(
        type: SyncType.transaction,
        current: currentPage,
        total: -1,
        overallProgress: pullProgress,
      );
    }
  }
}
