import '../../../../../core/utils/size_app_utils.dart';
import '../../../../../export/core_external.dart';
import '../../../data/model/sync_batch_progress.dart';
import '../../repositories/category_sync_repository.dart';

@injectable
class PushCategoryUseCase {
  final CategorySyncRepository _categorySyncRepository;

  PushCategoryUseCase(this._categorySyncRepository);

  int get _limit => SizeAppUtils().isTablet ? 20 : 10;

  Stream<SyncBatchProgress> execute() async* {
    final initialStatus = await _categorySyncRepository.getCategorySyncStatus();
    final int totalToPush = initialStatus.notSynced;

    if (totalToPush <= 0) {
      yield _buildProgress(current: 0, total: 0, progress: 0.5);
      return;
    }

    int pushedCount = 0;
    while (pushedCount < totalToPush) {
      final result = await _categorySyncRepository.pushCategoryDelta(_limit);

      // Forward event from result
      yield* result.fold((failure) => throw failure, (count) async* {
        if (count == 0) {
          pushedCount = totalToPush;
          return;
        }

        pushedCount += count;
        double progress = (pushedCount / totalToPush) * 0.5;

        yield _buildProgress(
          current: pushedCount,
          total: totalToPush,
          progress: progress,
        );
      });

      // Safety break
      if (result.getOrElse(() => 0) == 0) break;
    }
  }

  SyncBatchProgress _buildProgress({
    required int current,
    required int total,
    required double progress,
  }) {
    return SyncBatchProgress(
      type: SyncType.category,
      current: current,
      total: total,
      overallProgress: progress,
    );
  }
}
