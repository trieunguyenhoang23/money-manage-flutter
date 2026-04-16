import '../../../../../export/core_external.dart';
import '../../../../../export/ui_external.dart';
import '../../../data/model/sync_batch_progress.dart';
import 'pull_category_usecase.dart';
import 'push_category_usecase.dart';

@injectable
class SyncCateUseCase {
  final PushCategoryUseCase _pushCategoryUseCase;
  final PullCategoryUseCase _pullCategoryUseCase;

  SyncCateUseCase(this._pushCategoryUseCase, this._pullCategoryUseCase);

  Stream<SyncBatchProgress> execute() async* {
    try {
      /// Stage 1: PUSH LOCAL DATA TO SERVER(0.0 -> 0.5 overallProgress)
      yield* _pushCategoryUseCase.execute();

      /// Stage 2: PULL SERVER TO LOCAL (0.5 -> 1.0 overallProgress)
      yield* _pullCategoryUseCase.execute();
    } catch (e, stack) {
      debugPrint("DEBUG: Sync Error: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }
}
