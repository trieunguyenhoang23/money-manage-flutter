import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../../../../export/core_external.dart';
import '../../domain/sync_task/i_sync_task.dart';
import '../../domain/usecase/sync_category_usecase.dart';
import '../model/sync_batch_progress.dart';

@lazySingleton
class CategorySyncTask implements ISyncTask {
  final SyncCateUseCase _useCase;

  late BehaviorSubject<SyncBatchProgress> _controller;

  CategorySyncTask(this._useCase) {
    _controller = BehaviorSubject<SyncBatchProgress>();
  }

  @override
  SyncType get type => SyncType.category;

  @override
  BehaviorSubject<SyncBatchProgress> get controller => _controller;

  @override
  Stream<SyncBatchProgress> execute() => _useCase.execute();

  @override
  void reset() {
    _controller.close();
    _controller = BehaviorSubject<SyncBatchProgress>();
  }
}
