import 'package:flutter/material.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../../shared/widget/component/loading_widget.dart';
import '../../data/model/sync_batch_progress.dart';
import 'sync_error_widget.dart';
import 'sync_loading_widget.dart';
import 'sync_progress_widget.dart';

class SyncProgressBuilderWidget extends StatefulWidget {
  final SyncType syncType;
  final Stream<SyncBatchProgress> Function() syncStreamFactory;
  final Future<({int total, int notSynced})> Function() getSyncStatus;
  final VoidCallback onCompleted;
  final VoidCallback onRetry;

  const SyncProgressBuilderWidget({
    super.key,
    required this.syncType,
    required this.syncStreamFactory,
    required this.onCompleted,
    required this.onRetry,
    required this.getSyncStatus,
  });

  @override
  State<SyncProgressBuilderWidget> createState() =>
      _SyncProgressBuilderWidgetState();
}

class _SyncProgressBuilderWidgetState extends State<SyncProgressBuilderWidget> {
  final ValueNotifier<int> _retryKey = ValueNotifier(0);

  void _handleRetry() {
    setState(() {
      _retryKey.value++;
    });
    widget.onRetry();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<({int total, int notSynced})>(
      future: widget.getSyncStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const LoadingWidget();
        }

        if (snapshot.hasData) {
          return SyncProgressWidget(
            key: ValueKey('progress_widget_${_retryKey.value}'),
            syncStream: widget.syncStreamFactory(),
            syncType: widget.syncType,
            onCompleted: widget.onCompleted,
            onRetry: _handleRetry,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
