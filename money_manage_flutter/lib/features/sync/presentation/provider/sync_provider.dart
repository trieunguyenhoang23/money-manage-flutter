import 'package:money_manage_flutter/export/core.dart';
import '../../../../export/ui_external.dart';
import '../../../category/presentation/provider/category_provider.dart';
import '../../../main_features/transactions/presentation/provider/transaction_provider.dart';
import '../../data/model/sync_batch_progress.dart';
import '../../domain/repositories/category_sync_repository.dart';
import '../../domain/repositories/transaction_sync_repository.dart';
import 'sync_manager_provider.dart';

/// Category Stream
final categorySyncProvider = StreamProvider.autoDispose<SyncBatchProgress>((
  ref,
) {
  final manager = ref.watch(syncManagerProvider.notifier);
  return manager.streamByType(SyncType.category);
});

/// Provider cho Transaction
final transactionSyncProvider = StreamProvider.autoDispose<SyncBatchProgress>((
  ref,
) {
  final manager = ref.watch(syncManagerProvider.notifier);
  return manager.streamByType(SyncType.transaction);
});

/// Category Status Sync Information
final categorySyncStatusProvider = FutureProvider<({int total, int notSynced})>(
  (ref) async {
    final repo = getIt<CategorySyncRepository>();
    final data = await repo.getCategorySyncStatus();
    return data;
  },
);

/// Transaction Status Sync Information
final transactionSyncStatusProvider =
    FutureProvider<({int total, int notSynced})>((ref) async {
      final repo = getIt<TransactionSyncRepository>();
      return await repo.getTransactionSyncStatus();
    });
