import 'package:money_manage_flutter/shared/widget/dialog/ui/dialog_pick_file_widget.dart';

import '../../../export/core.dart';
import '../../../export/ui_external.dart';
import '../../../infrastructure/file/models/file_picked.dart';

class DialogUtils {
  static loading(BuildContext context) {
    return showDialog(
      useRootNavigator: true,
      context: appNavigatorKey.currentContext!,
      barrierDismissible: true,
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
}
