import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';

class DialogBg1Widget extends StatelessWidget {
  final double w;
  final Widget child;

  const DialogBg1Widget({super.key, required this.w, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(0.8.sw * 0.075)),
        color: context.colorScheme.surface,
      ),
      child: child,
    );
  }
}
