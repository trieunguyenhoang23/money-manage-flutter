import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../data/model/sync_batch_progress.dart';

class SyncErrorWidget extends StatelessWidget {
  final String errorMessage;
  final SyncType syncType;
  final VoidCallback onRetry;

  const SyncErrorWidget({
    super.key,
    required this.errorMessage,
    required this.syncType,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cc) {
        return Card(
          elevation: 0,
          color: ColorConstant.error400.withValues(alpha: 0.75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cc.maxHeight * 0.15),
          ),
          child: Padding(
            padding: EdgeInsets.all(cc.maxHeight * 0.025),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off,
                  color: Colors.white,
                  size: 0.25 * cc.maxHeight,
                ),
                const Spacer(),
                Flexible(
                  flex: 3,
                  child: TextGGStyle(
                    errorMessage,
                    cc.maxHeight * 0.1,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.neutral200,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Flexible(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: Text(context.lang.retry),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.error500,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
