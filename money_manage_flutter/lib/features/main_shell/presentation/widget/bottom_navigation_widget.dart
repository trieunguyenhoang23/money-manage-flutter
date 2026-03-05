import '../main_tab.dart';
import '../../../../export/ui_external.dart';
import '../../../../core/constant/color_constant.dart';
import 'package:money_manage_flutter/export/shared.dart';

class BottomNavigationWidget extends StatelessWidget {
  final BottomTabBar tab;
  final bool isSelected;

  const BottomNavigationWidget({
    super.key,
    required this.tab,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? ColorConstant.primary : ColorConstant.neutral300;

    return LayoutBuilder(
      builder: (context, cc) {
        double h = cc.maxHeight;
        double icSize = h * 0.4;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 0.05 * h),
            tab.icon.runtimeType == String
                ? Image.asset(
                    tab.icon,
                    width: icSize,
                    height: icSize,
                    color: color,
                  )
                : Icon(tab.icon, size: icSize, color: color),
            TextGGStyle(
              tab.label(context),
              0.2 * h,
              maxLines: 1,
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ],
        );
      },
    );
  }
}
