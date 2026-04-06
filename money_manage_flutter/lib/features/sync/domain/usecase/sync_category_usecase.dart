import '../../../../export/core_external.dart';
import '../../data/datasource/local/sync_local_storage.dart';
import '../../data/model/sync_batch_progress.dart';
import '../repositories/sync_repository.dart';

@injectable
class SyncCateUseCase {
  final SyncRepository _syncRepository;
  final SyncLocalStorage _syncLocalStorage;

  SyncCateUseCase(this._syncRepository, this._syncLocalStorage);

  static const limitCount = 20;

  Stream<SyncBatchProgress> execute() async* {
    final schema = SyncSchema.category;
    // =========================================================
    // Stage 1: PUSH LOCAL CATEGORIES TO SERVER (0.0 -> 0.5)
    // =========================================================
    final currentStatus = await _syncRepository.getCategorySyncStatus();
    final int pushTotal = currentStatus.notSynced;
    int pushRemaining = pushTotal;

    if (pushTotal > 0) {
      while (pushRemaining > 0) {
        final result = await _syncRepository.syncCategory(limitCount);

        if (result.isLeft()) {
          throw result.fold((l) => l, (r) => null)!;
        }

        final newStatus = await _syncRepository.getCategorySyncStatus();
        pushRemaining = newStatus.notSynced;

        // 0% -> 50%
        double progress = ((pushTotal - pushRemaining) / pushTotal) * 0.5;

        yield SyncBatchProgress(
          type: SyncType.category,
          current: pushTotal - pushRemaining,
          total: pushTotal,
          overallProgress: progress,
        );
      }
    } else {
      yield SyncBatchProgress(
        type: SyncType.category,
        current: 0,
        total: 0,
        overallProgress: 0.5,
      );
    }

    // =========================================================
    // Stage 2: PULL SERVER CATEGORIES TO LOCAL (0.5 -> 1.0)
    // =========================================================
    if (_syncLocalStorage.hasReachedEnd(schema)) {
      yield SyncBatchProgress(
        type: SyncType.category,
        current: 100,
        total: 100,
        overallProgress: 1.0,
      );
      return;
    }

    bool hasMore = true;
    while (hasMore) {
      final pullResult = await _syncRepository.loadCateByPageFromServer();

      if (pullResult.isLeft()) {
        throw pullResult.fold((l) => l, (r) => null)!;
      }

      hasMore = pullResult.getOrElse(() => false);

      // 0.5 => 1.0
      int currentPage = _syncLocalStorage.getLastPage(schema);
      double pullProgress =
          0.5 +
          (0.5 * (hasMore ? (currentPage / (currentPage + 1)) * 0.9 : 1.0));

      yield SyncBatchProgress(
        type: SyncType.category,
        current: currentPage,
        total: -1,
        overallProgress: pullProgress,
      );
    }
  }
}
