import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../data/model/sync_batch_progress.dart';
import '../provider/sync_manager_provider.dart';
import '../provider/sync_provider.dart';
import 'sync_error_widget.dart';
import 'sync_loading_widget.dart';

class SyncProgressBuilderWidget extends ConsumerWidget {
  final SyncType syncType;

  const SyncProgressBuilderWidget({super.key, required this.syncType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(syncStreamProvider(syncType));

    return progressAsync.when(
      data: (progress) {
        return SyncLoadingWidget(
          progress: progress,
          title: _getTitleForType(context),
        );
      },
      loading: () => SyncLoadingWidget(
        progress: SyncBatchProgress(
          overallProgress: 0,
          type: syncType,
          current: 0,
          total: 0,
        ),
        title: _getTitleForType(context),
      ),
      error: (e, _) => SyncErrorWidget(
        errorMessage: e.toString(),
        syncType: syncType,
        onRetry: () =>
            ref.read(syncManagerProvider.notifier).initSync(type: syncType),
      ),
    );
  }

  String _getTitleForType(BuildContext context) {
    return "${context.lang.sync_loading} ${syncType.name.toUpperCase()}...";
  }
}
