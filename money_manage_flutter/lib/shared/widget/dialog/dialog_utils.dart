import '../../../export/core.dart';
import '../../../export/ui_external.dart';
import '../../../infrastructure/file/models/file_picked.dart';
import 'ui/dialog_handle_decision_widget.dart';
import 'ui/dialog_pick_file_widget.dart';

class DialogUtils {
  static loading(BuildContext context) {
    return showDialog(
      useRootNavigator: true,
      context: appNavigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (s, i) => Future.value(true),
        child: Center(
          child: SizedBox(
            width: 0.05.sw,
            height: 0.05.sw,
            child: const CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }

  static Future<FilePicked?> pickFile(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const DialogPickFileWidget();
      },
    );
  }

  static Future<T?> handleDecision<T>(
    BuildContext context, {
    required String title,
    String? content,
     String? confirmLabel,
     VoidCallback? onConfirm,
    String? cancelLabel,
    VoidCallback? onCancel,
    Color? confirmColor,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => DecisionDialog(
        title: title,
        content: content,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        cancelLabel: cancelLabel,
        onCancel: onCancel,
        confirmColor: confirmColor,
      ),
    );
  }
}
