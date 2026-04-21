import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../data/model/sync_batch_progress.dart';

class SyncLoadingWidget extends StatelessWidget {
  final SyncBatchProgress progress;
  final String title;

  const SyncLoadingWidget({
    super.key,
    required this.progress,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = progress.overallProgress >= 1.0;

    return LayoutBuilder(
      builder: (context, cc) {
        double maxWidth = cc.maxWidth;
        double maxHeight = cc.maxHeight;

        double textSize = 0.1 * maxHeight;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDone ? Colors.green.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(0.025.sw),
            boxShadow: [
              shadowStyle(
                context.colorScheme.onSurface.withValues(alpha: 0.5),
                const Offset(0, 2),
                5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    isDone ? Icons.check_circle : Icons.sync,
                    color: ColorConstant.warning700,
                    size: 0.15 * maxHeight,
                  ),
                  SizedBox(width: 0.025 * maxWidth),
                  Expanded(
                    child: TextGGStyle(
                      progress.type.name.toUpperCase(),
                      textSize,
                      color: isDone
                          ? ColorConstant.success700
                          : ColorConstant.neutral700,
                      fontWeight: FontWeight.bold,
                      maxLines: 1,
                    ),
                  ),
                  if (isDone)
                    Icon(
                      Icons.done_all,
                      color: ColorConstant.success700,
                      size: 0.15 * maxHeight,
                    ),
                ],
              ),
              SizedBox(height: 0.1 * maxHeight),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress.overallProgress,
                  backgroundColor: ColorConstant.neutral200,
                  minHeight: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDone
                        ? ColorConstant.success500
                        : ColorConstant.warning700,
                  ),
                ),
              ),
              SizedBox(height: 0.05 * maxHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextGGStyle(
                      '${(progress.overallProgress * 100).toInt()}%',
                      textSize,
                      color: isDone
                          ? ColorConstant.success400
                          : ColorConstant.warning700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: TextGGStyle(
                      isDone
                          ? context.lang.sync_complete
                          : '${progress.current}/${progress.total}',
                      textSize,
                      color: isDone
                          ? ColorConstant.success400
                          : ColorConstant.neutral200,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

