import 'dart:async';
import 'package:money_manage_flutter/export/core.dart';
import '../../../../export/core_external.dart';
import '../../../../export/ui_external.dart';
import '../../../../shared/state/connection_state.dart';
import '../../data/model/sync_batch_progress.dart';
import '../../domain/sync_task/i_sync_task.dart';

class SyncState {
  final bool isSyncing;
  final SyncType currentSync;
  final Map<SyncType, SyncBatchProgress> progress;

  SyncState({
    this.isSyncing = false,
    this.progress = const {},
    this.currentSync = SyncType.all,
  });

  SyncState copyWith({
    bool? isSyncing,
    Map<SyncType, SyncBatchProgress>? progress,
    SyncType? currentSync,
  }) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      progress: progress ?? this.progress,
      currentSync: currentSync ?? this.currentSync,
    );
  }
}

@injectable
class SyncManagerNotifier extends Notifier<SyncState> {
  late final OnlineActionGuard _onlineActionGuard;
  late final List<ISyncTask> _tasks;
  Timer? _debounceTimer;

  SyncManagerNotifier(this._onlineActionGuard, this._tasks);

  @override
  SyncState build() {
    // Dispose data
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });

    ref.listen<AsyncValue<bool>>(connectivityStreamProvider, (previous, next) {
      final isOnline = next.value ?? false;
      final wasOnline = previous?.value ?? true;

      if (isOnline && !wasOnline) {
        debugPrint("🌐 Back online: Resetting and starting fresh...");
        state = SyncState();
        initSync();
      }
    });

    /// Init for the first time
    Future.microtask(() => initSync());
    return SyncState();
  }

  Future<void> initSync({SyncType type = SyncType.all}) async {
    /// Skip if isSyncing = true
    if (state.isSyncing && type == SyncType.all) return;

    await _onlineActionGuard.run((userId, isConnected) async {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(const Duration(seconds: 2), () async {
        state = state.copyWith(isSyncing: true, currentSync: type);

        if (type == SyncType.all) {
          for (var task in _tasks) {
            await _executeTask(task);
          }
        } else {
          final task = _tasks.firstWhere((t) => t.type == type);
          await _executeTask(task);
        }
      });
    });
  }

  Future<void> _executeTask(ISyncTask task) async {
    try {
      task.reset();

      final initialProgress = SyncBatchProgress(
        type: task.type,
        current: 0,
        total: 0,
        overallProgress: 0.01,
      );

      // Send progress 0% immediately to avoid UI freeze
      task.controller.add(initialProgress);
      _updateStateProgress(task.type, initialProgress);

      await for (final p in task.execute()) {
        task.controller.add(p);
        _updateStateProgress(task.type, p);
      }
    } catch (e) {
      state = state.copyWith(isSyncing: false);
    }
  }

  void _updateStateProgress(SyncType type, SyncBatchProgress p) {
    final newProgressMap = Map<SyncType, SyncBatchProgress>.from(
      state.progress,
    );
    newProgressMap[type] = p;
    state = state.copyWith(
      progress: newProgressMap,
      isSyncing: _checkGlobalSyncStatus(newProgressMap),
    );
  }

  Stream<SyncBatchProgress> streamByType(SyncType type) {
    return _tasks.firstWhere((t) => t.type == type).controller.stream;
  }

  bool _checkGlobalSyncStatus(Map<SyncType, SyncBatchProgress> map) {
    return map.values.any((element) => element.overallProgress < 1.0);
  }
}

final syncManagerProvider = NotifierProvider<SyncManagerNotifier, SyncState>(
  () => getIt<SyncManagerNotifier>(),
);
