import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/shared/widget/component/loading_widget.dart';
import 'dart:async';
import '../../data/model/sync_batch_progress.dart';
import 'sync_error_widget.dart';
import 'sync_loading_widget.dart';

class SyncProgressWidget extends StatefulWidget {
  final Stream<SyncBatchProgress> syncStream;
  final VoidCallback onCompleted;
  final VoidCallback onRetry;
  final SyncType syncType;

  const SyncProgressWidget({
    super.key,
    required this.syncStream,
    required this.onCompleted,
    required this.onRetry,
    required this.syncType,
  });

  @override
  State<SyncProgressWidget> createState() => _SyncProgressWidgetState();
}

class _SyncProgressWidgetState extends State<SyncProgressWidget> {
  StreamSubscription<SyncBatchProgress>? _subscription;
  SyncBatchProgress? _lastProgress;
  String? _errorMessage;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _subscription?.cancel();
    _subscription = widget.syncStream.listen(
      (progress) {
        if (!mounted) return;
        setState(() {
          _lastProgress = progress;
          _errorMessage = null;
        });

        if (progress.overallProgress >= 1.0 && !_isCompleted) {
          _isCompleted = true;
          widget.onCompleted();
        }
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _errorMessage = (error as Failure).message;
        });
      },
      onDone: () {
        widget.onCompleted();
      },
      cancelOnError: true,
    );
  }

  void _handleRetry() {
    setState(() {
      _errorMessage = null;
    });

    widget.onRetry();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return SyncErrorWidget(
        errorMessage: _errorMessage!,
        syncType: widget.syncType,
        onRetry: _handleRetry,
      );
    }

    if (_lastProgress != null) {
      return SyncLoadingWidget(
        progress: _lastProgress!,
        activeColor: _getColorForType(),
        title: _getTitleForType(),
      );
    }

    return const LoadingWidget();
  }

  Color _getColorForType() {
    switch (widget.syncType) {
      case SyncType.category:
        return Colors.orange;
      case SyncType.transaction:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _getTitleForType() {
    return "${context.lang.sync_loading} ${widget.syncType.name.toUpperCase()}...";
  }
}
