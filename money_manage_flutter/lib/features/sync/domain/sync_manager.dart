import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:money_manage_flutter/core/network/online_action_guard.dart';
import 'package:rxdart/rxdart.dart';

import '../../../export/core_external.dart';
import '../data/model/sync_batch_progress.dart';
import 'usecase/sync_category_usecase.dart';
import 'usecase/sync_transaction_usecase.dart';

@lazySingleton
class SyncManager {
  final SyncCateUseCase _syncCateUseCase;
  final SyncTransactionUseCase _syncTransactionUseCase;
  final OnlineActionGuard _onlineActionGuard;

  final _cateController = BehaviorSubject<SyncBatchProgress>();
  final _transController = BehaviorSubject<SyncBatchProgress>();

  Stream<SyncBatchProgress> get cateStream => _cateController.stream;

  Stream<SyncBatchProgress> get transStream => _transController.stream;

  SyncManager(
    this._syncCateUseCase,
    this._syncTransactionUseCase,
    this._onlineActionGuard,
  );

  Future<void> initSync() async {
    await _onlineActionGuard.run((currentUserId, isConnectInternet) async {
      _startCateSync();
      _startTransSync();
    });
  }

  void _startCateSync() async {
    _syncCateUseCase.execute().listen(
      (p) {
        _cateController.add(p);
        if (p.overallProgress >= 1.0) {
          debugPrint("Category Sync Finished!");
        }
      },
      onError: (e) => _cateController.addError(e),
      onDone: () => debugPrint("Stream Source Closed"),
    );
  }

  void _startTransSync() async {
    _syncTransactionUseCase.execute().listen(
      (p) {
        _transController.add(p);

        if (p.overallProgress >= 1.0) {
          debugPrint("Transaction Sync: Hoàn thành 100%");
        }
      },
      onError: (e) {
        _transController.addError(e);
      },
      onDone: () {
        debugPrint("Transaction Sync: Stream source đã đóng.");
      },
    );
  }

  @disposeMethod
  void dispose() {
    _cateController.close();
    _transController.close();
  }
}
