import 'package:money_manage_flutter/export/ui_external.dart';

class BtnMainWidget extends StatelessWidget {
  final double w;
  final double h;
  final double radius;
  final Widget child;
  final Color? color;
  final Function()? onTap;
  final LinearGradient? gradient;
  final Border? border;

  const BtnMainWidget({
    super.key,
    required this.w,
    required this.h,
    required this.radius,
    required this.child,
    this.color,
    this.onTap,
    this.gradient,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          border: border,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: child,
      ),
    );
  }
}
