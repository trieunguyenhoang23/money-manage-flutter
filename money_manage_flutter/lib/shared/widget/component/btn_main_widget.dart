import 'package:money_manage_flutter/export/ui_external.dart';

import '../../../core/utils/size_app_utils.dart';

class BtnMainWidget extends StatelessWidget {
  final double? w;
  final double? h;
  final double? radius;
  final Widget child;
  final Color? color;
  final Function()? onTap;
  final LinearGradient? gradient;
  final Border? border;

  const BtnMainWidget({
    super.key,
    this.w,
    this.h,
    this.radius,
    required this.child,
    this.color,
    this.onTap,
    this.gradient,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    double wBtn = w ?? SizeAppUtils().wScreenWithPadding;
    double hBtn = h ?? wBtn * 46 / 344;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: wBtn,
        height: hBtn,
        decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          border: border,
          borderRadius: BorderRadius.all(
            Radius.circular(radius ?? hBtn * 0.1),
          ),
        ),
        child: child,
      ),
    );
  }
}
