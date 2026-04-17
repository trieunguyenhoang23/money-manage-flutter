import '../../../../core/di/injection.dart';
import '../../../../export/ui_external.dart';
import '../../../../infrastructure/network/socket/i_socket_client_service.dart';
import '../../../../infrastructure/network/socket/sync_socket_service_impl.dart';
import '../../../category/presentation/provider/category_provider.dart';
import '../../../main_features/profile/presentation/provider/profile_provider.dart';
import '../../../main_features/transactions/presentation/provider/transaction_provider.dart';
import '../../data/model/sync_batch_progress.dart';
import 'sync_manager_provider.dart';

/// Socket
final socketObserverProvider = Provider<void>((ref) {
  /// IMPORTANT: automatically trigger because watch profile
  final profile = ref.watch(profileProvider);
  final user = profile.value?.userLocalModel;

  if (user != null) {
    final socketService = getIt<ISocketClientService>();
    socketService.init();

    final subscription = (socketService as SocketClientServiceImpl).syncEvents
        .listen((type) {
          ref
              .read(syncManagerProvider.notifier)
              .initSync(type: SyncType.fromDynamic(type));
        });

    ref.onDispose(() {
      subscription.cancel();
      socketService.dispose();
      debugPrint('Subscription cancelled, but Socket kept alive');
    });
  }
});

/// Trigger rebuild list of item from real-time socket
final syncObserverProvider = Provider<void>((ref) {
  ref.listen<SyncState>(syncManagerProvider, (previous, next) {
    next.progress.forEach((type, currentProgress) {
      final prevProgress = previous?.progress[type]?.overallProgress ?? 0.0;

      if (currentProgress.overallProgress >= 1.0 &&
          prevProgress < 1.0 &&
          /// Not update UI when SyncType is all
          ref.read(syncManagerProvider).currentSync != SyncType.all) {
        _handleSyncCompletion(ref, type);
      }
    });
  });
});

void _handleSyncCompletion(Ref ref, SyncType type) {
  switch (type) {
    case SyncType.category:
      ref.invalidate(loadingCategoryProvider);
      break;
    case SyncType.transaction:
      ref.invalidate(loadingTransactionProvider);
      break;
    case SyncType.all:
      // ref.invalidate(loadingCategoryProvider);
      // ref.invalidate(loadingTransactionProvider);
      break;
  }
}
