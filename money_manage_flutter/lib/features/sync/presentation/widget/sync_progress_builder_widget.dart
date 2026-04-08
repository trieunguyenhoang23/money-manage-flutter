import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/features/category/presentation/provider/category_provider.dart';
import 'package:money_manage_flutter/features/main_features/transactions/presentation/provider/transaction_provider.dart';
import 'package:money_manage_flutter/features/sync/presentation/provider/sync_manager_provider.dart';
import '../../data/model/sync_batch_progress.dart';
import '../provider/sync_provider.dart';
import 'sync_error_widget.dart';
import 'sync_loading_widget.dart';

class SyncProgressBuilderWidget extends ConsumerWidget {
  final SyncType syncType;

  const SyncProgressBuilderWidget({super.key, required this.syncType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbStatusAsync = syncType == SyncType.category
        ? ref.watch(categorySyncStatusProvider)
        : ref.watch(transactionSyncStatusProvider);

    final progressAsync = syncType == SyncType.category
        ? ref.watch(categorySyncProvider)
        : ref.watch(transactionSyncProvider);

    return dbStatusAsync.when(
      loading: () => const LoadingWidget(),
      error: (err, stack) => Center(child: Text('Lỗi: $err')),
      data: (status) {
        return progressAsync.when(
          data: (progress) {
            return SyncLoadingWidget(
              progress: progress,
              title: _getTitleForType(context),
            );
          },
          loading: () => const LoadingWidget(),
          error: (e, _) => SyncErrorWidget(
            errorMessage: e.toString(),
            syncType: syncType,
            onRetry: () =>
                ref.read(syncManagerProvider.notifier).initSync(type: syncType),
          ),
        );
      },
    );
  }

  String _getTitleForType(BuildContext context) {
    return "${context.lang.sync_loading} ${syncType.name.toUpperCase()}...";
  }
}
