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
    return Card(
      elevation: 0,
      color: ColorConstant.error400.withValues(alpha: 0.75),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.05.sw),
      ),
      child: Padding(
        padding: EdgeInsets.all(0.015.sw),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(
              flex: 3,
              child: Icon(Icons.cloud_off, color: ColorConstant.error500),
            ),

            Flexible(
              flex: 3,
              child: TextGGStyle(
                errorMessage,
                0.025.sw,
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
  }
}
