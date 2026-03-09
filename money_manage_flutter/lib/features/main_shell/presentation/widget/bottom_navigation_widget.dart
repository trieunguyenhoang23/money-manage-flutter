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
    final color = isSelected ? ColorConstant.primary : ColorConstant.neutral200;

    return LayoutBuilder(
      builder: (context, cc) {
        double h = cc.maxHeight;
        double icSize = h * 0.5;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            tab.icon.runtimeType == String
                ? Image.asset(
                    tab.icon,
                    width: icSize,
                    height: icSize,
                    color: color,
                  )
                : Icon(tab.icon, size: icSize, color: color),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: TextGGStyle(
                  tab.label(context),
                  0.25 * h,
                  maxLines: 1,
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
