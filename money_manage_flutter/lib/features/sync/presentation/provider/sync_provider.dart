import '../../../../export/ui_external.dart';
import '../../data/model/sync_batch_progress.dart';
import 'sync_manager_provider.dart';

/// Stream Provider
final syncStreamProvider = StreamProvider.autoDispose
    .family<SyncBatchProgress, SyncType>((ref, type) {
      final manager = ref.watch(syncManagerProvider.notifier);
      return manager.streamByType(type);
    });
