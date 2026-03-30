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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDone ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(0.025.sw),
        boxShadow: [
          shadowStyle(
            Colors.black12.withValues(alpha: 0.05),
            const Offset(0, 4),
            5,
          ),
        ],
        border: Border.all(color: context.colorScheme.onBackground, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                isDone ? Icons.check_circle : Icons.sync,
                color: ColorConstant.warning700,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextGGStyle(
                  progress.type.name.toUpperCase(),
                  0.035.sw,
                  color: isDone
                      ? ColorConstant.success700
                      : ColorConstant.neutral700,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                ),
              ),
              if (isDone)
                const Icon(
                  Icons.done_all,
                  color: ColorConstant.success700,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.overallProgress,
              backgroundColor: ColorConstant.neutral200,
              minHeight: 8,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDone ? ColorConstant.success500 : ColorConstant.warning700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: TextGGStyle(
                  '${(progress.overallProgress * 100).toInt()}%',
                  0.035.sw,
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
                  0.035.sw,
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
  }
}
