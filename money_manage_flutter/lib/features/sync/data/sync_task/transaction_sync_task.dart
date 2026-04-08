import 'package:rxdart/rxdart.dart';
import '../../../../export/core_external.dart';
import '../../domain/sync_task/i_sync_task.dart';
import '../../domain/usecase/sync_transaction_usecase.dart';
import '../model/sync_batch_progress.dart';

@lazySingleton
class TransactionSyncTask implements ISyncTask {
  final SyncTransactionUseCase _useCase;

  late BehaviorSubject<SyncBatchProgress> _controller;

  TransactionSyncTask(this._useCase) {
    _controller = BehaviorSubject<SyncBatchProgress>();
  }

  @override
  SyncType get type => SyncType.transaction;

  @override
  BehaviorSubject<SyncBatchProgress> get controller => _controller;

  @override
  Stream<SyncBatchProgress> execute() => _useCase.execute();

  @override
  void reset() {
    _controller.close();
    _controller = BehaviorSubject<SyncBatchProgress>();
  }

  void dispose() {
    _controller.close();
  }
}
