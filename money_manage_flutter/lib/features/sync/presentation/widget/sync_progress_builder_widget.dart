import 'package:flutter/material.dart';
import 'package:money_manage_flutter/core/constant/color_constant.dart';
import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../../shared/widget/component/loading_widget.dart';
import '../../data/model/sync_batch_progress.dart';
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
      _retryKey
          .value++; // Tăng key để force FutureBuilder gọi lại syncStreamFactory()
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
          final data = snapshot.data!;

          if (data.notSynced > 0) {
            return SyncProgressWidget(
              key: ValueKey('progress_widget_$_retryKey'),
              syncStream: widget.syncStreamFactory(),
              syncType: widget.syncType,
              onCompleted: widget.onCompleted,
              onRetry: _handleRetry,
            );
          }

          return SyncLoadingWidget(
            progress: SyncBatchProgress(
              type: widget.syncType,
              current: data.total,
              total: data.total,
              overallProgress: 1,
            ),
            activeColor: ColorConstant.success400,
            title: '${context.lang.sync_complete} ${widget.syncType.name}',
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
