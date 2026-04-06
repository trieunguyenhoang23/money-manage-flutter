import '../../../../core/utils/size_app_utils.dart';
import '../../../../export/core_external.dart';
import '../../data/datasource/local/sync_local_storage.dart';
import '../../data/model/sync_batch_progress.dart';
import '../repositories/category_sync_repository.dart';

@injectable
class SyncCateUseCase {
  final CategorySyncRepository _categorySyncRepository;
  final SyncLocalStorage _syncLocalStorage;

  SyncCateUseCase(this._categorySyncRepository, this._syncLocalStorage);

  int limitCount = SizeAppUtils().isTablet ? 20 : 10;

  Stream<SyncBatchProgress> execute() async* {
    final schema = SyncSchema.category;
    // =========================================================
    // Stage 1: PUSH LOCAL CATEGORIES TO SERVER (0.0 -> 0.5)
    // =========================================================
    final currentStatus = await _categorySyncRepository.getCategorySyncStatus();
    final int pushTotal = currentStatus.notSynced;
    int pushRemaining = pushTotal;

    if (pushTotal > 0) {
      while (pushRemaining > 0) {
        final result = await _categorySyncRepository.syncCategory(limitCount);

        if (result.isLeft()) {
          throw result.fold((l) => l, (r) => null)!;
        }

        final newStatus = await _categorySyncRepository.getCategorySyncStatus();
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
    String? lastSync = _syncLocalStorage.getLastSyncTime(schema);
    bool hasMore = true;
    int currentPage = 0;

    while (hasMore) {
      final pullResult = await _categorySyncRepository.loadCateDelta(
        lastTimeSync: lastSync,
        page: currentPage,
      );

      if (pullResult.isLeft()) {
        throw pullResult.fold((l) => l, (r) => null)!;
      }

      final syncResponse = pullResult.fold(
        (failure) => throw failure,
        (response) => response,
      );

      hasMore = syncResponse.hasMore;

      double pullProgress =
          0.5 +
          (0.5 * (hasMore ? (currentPage / (currentPage + 1)) * 0.9 : 1.0));

      yield SyncBatchProgress(
        type: SyncType.category,
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
      type: SyncType.category,
      current: 100,
      total: 100,
      overallProgress: 1.0,
    );
  }
}
