import 'package:go_router/go_router.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../widget/dialog_bg_1_widget.dart';

class DecisionDialog extends StatelessWidget {
  final String title;
  final String? content;
  final String? confirmLabel;
  final VoidCallback? onConfirm;
  final String? cancelLabel;
  final VoidCallback? onCancel;
  final Color? confirmColor;

  const DecisionDialog({
    super.key,
    required this.title,
    this.content,
    this.confirmLabel,
    this.onConfirm,
    this.cancelLabel,
    this.onCancel,
    this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    final double width = SizeAppUtils().isTablet ? 0.6.sw : 0.8.sw;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 0.1.sw),
      child: DialogBg1Widget(
        w: width,
        child: LayoutBuilder(
          builder: (context, cc) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextGGStyle(
                    title,
                    cc.maxWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ),

                // Content
                if (content != null && content!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: TextGGStyle(
                      content!,
                      cc.maxWidth * 0.045,
                      color: ColorConstant.neutral400,
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  const SizedBox(height: 24),

                // Actions
                _buildAction(
                  label: confirmLabel ?? context.lang.confirm,
                  onTap: () {
                    context.pop();
                    onConfirm != null ? onConfirm!() : context.pop();
                  },
                  color: confirmColor ?? ColorConstant.primary,
                ),
                _buildAction(
                  label: cancelLabel ?? context.lang.cancel,
                  onTap: () {
                    onCancel != null ? onCancel!() : context.pop();
                  },
                  color: ColorConstant.error400,
                  isLast: true,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAction({
    required String label,
    required VoidCallback onTap,
    required Color color,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: ColorConstant.neutral300, width: 0.5),
          ),
        ),
        alignment: Alignment.center,
        child: TextGGStyle(
          label,
          16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
