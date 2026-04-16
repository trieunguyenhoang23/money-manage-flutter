import 'package:money_manage_flutter/export/core_external.dart';
import '../../../data/model/sync_batch_progress.dart';
import 'pull_transaction_usecase.dart';
import 'push_transaction_usecase.dart';

@LazySingleton()
class SyncTransactionUseCase {
  final PushTransactionUseCase _pushUseCase;
  final PullTransactionUseCase _pullUseCase;

  SyncTransactionUseCase(this._pushUseCase, this._pullUseCase);

  Stream<SyncBatchProgress> execute() async* {
    try {
      /// Stage 1: PUSH LOCAL DATA TO SERVER(0.0 -> 0.5 overallProgress)
      yield* _pushUseCase.execute();

      /// Stage 2: PULL SERVER TO LOCAL (0.5 -> 1.0 overallProgress)
      yield* _pullUseCase.execute();
    } catch (e) {
      rethrow;
    }
  }
}
