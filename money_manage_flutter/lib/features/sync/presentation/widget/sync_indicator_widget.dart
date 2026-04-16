import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_manage_flutter/core/constant/color_constant.dart';
import '../provider/socket_provider.dart';
import '../provider/sync_manager_provider.dart';

class SyncIndicatorWidget extends ConsumerWidget {
  const SyncIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSyncing = ref.watch(syncManagerProvider).isSyncing;
    ref.watch(socketObserverProvider);
    ref.watch(syncObserverProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: isSyncing ? const _SyncingIcon() : const _DoneIcon(),
    );
  }
}

class _SyncingIcon extends StatelessWidget {
  const _SyncingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.2, end: 1.0),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutSine,
      builder: (context, opacity, _) {
        return Opacity(
          opacity: opacity,
          child: const Icon(Icons.sync, color: ColorConstant.primary, size: 28),
        );
      },
    );
  }
}

class _DoneIcon extends StatelessWidget {
  const _DoneIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.cloud_done, color: ColorConstant.primary, size: 28);
  }
}
