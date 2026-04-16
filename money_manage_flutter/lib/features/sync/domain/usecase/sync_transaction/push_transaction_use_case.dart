import 'package:money_manage_flutter/export/core_external.dart';
import '../../../../../core/utils/size_app_utils.dart';
import '../../../data/model/sync_batch_progress.dart';
import '../../repositories/transaction_sync_repository.dart';

@LazySingleton()
class PushTransactionUseCase {
  final TransactionSyncRepository _transactionSyncRepository;

  PushTransactionUseCase(this._transactionSyncRepository);

  int limitCount = SizeAppUtils().isTablet ? 20 : 1;

  Stream<SyncBatchProgress> execute() async* {
    // Get sync data first time
    final initialStatus = await _transactionSyncRepository
        .getTransactionSyncStatus();
    final int totalToPush = initialStatus.notSynced;

    if (totalToPush == 0) {
      yield SyncBatchProgress(
        type: SyncType.transaction,
        current: 0,
        total: 0,
        overallProgress: 0.5,
      );
      return;
    }

    int pushedCount = 0;
    bool hasMoreLocalData = true;

    while (hasMoreLocalData) {
      final result = await _transactionSyncRepository.pushTransactionDelta(
        limitCount,
      );

      // Handle Error
      if (result.isLeft()) throw result.fold((l) => l, (r) => null)!;

      final int batchProcessed = result.getOrElse(() => 0);
      pushedCount += batchProcessed;

      // Update to the latest status to check the stop conditions
      final currentStatus = await _transactionSyncRepository
          .getTransactionSyncStatus();
      hasMoreLocalData = currentStatus.notSynced > 0 && batchProcessed > 0;

      double progress = (pushedCount / totalToPush) * 0.5;

      yield SyncBatchProgress(
        type: SyncType.transaction,
        current: pushedCount,
        total: totalToPush,
        overallProgress: progress,
      );
    }
  }
}

