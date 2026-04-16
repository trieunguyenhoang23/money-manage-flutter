import 'dart:async';
import 'package:money_manage_flutter/export/core.dart';
import '../../../../export/core_external.dart';
import '../../../../export/ui_external.dart';
import '../../data/model/sync_batch_progress.dart';
import '../../domain/sync_task/i_sync_task.dart';

class SyncState {
  final bool isSyncing;
  final Map<SyncType, SyncBatchProgress> progress;

  SyncState({this.isSyncing = false, this.progress = const {}});

  SyncState copyWith({
    bool? isSyncing,
    Map<SyncType, SyncBatchProgress>? progress,
  }) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      progress: progress ?? this.progress,
    );
  }
}

@injectable
class SyncManagerNotifier extends Notifier<SyncState> {
  late final OnlineActionGuard _onlineActionGuard;
  late final List<ISyncTask> _tasks;

  SyncManagerNotifier(this._onlineActionGuard, this._tasks);

  @override
  SyncState build() {
    return SyncState();
  }

  Future<void> initSync({SyncType type = SyncType.all}) async {
    await _onlineActionGuard.run((userId, isConnected) async {
      state = state.copyWith(isSyncing: true);

      if (type == SyncType.all) {
        for (var task in _tasks) {
          await _executeTask(task);
        }
      } else {
        final task = _tasks.firstWhere((t) => t.type == type);
        await _executeTask(task);
      }
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
