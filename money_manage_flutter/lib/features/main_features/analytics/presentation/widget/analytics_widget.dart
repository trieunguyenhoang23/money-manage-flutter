import 'package:money_manage_flutter/core/constant/color_constant.dart';
import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/core/router/navigator_router.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';

class AnalyticsWidget extends StatelessWidget {
  final String title;
  final IconData iconData;
  final String namePath;

  const AnalyticsWidget({
    super.key,
    required this.title,
    required this.iconData,
    required this.namePath,
  });

  @override
  Widget build(BuildContext context) {
    double wFrame = 1.sw - 0.05.sw;
    double hFrame = wFrame / 4;
    return InkWell(
      onTap: () {
        NavigatorRouter.pushNamed(context, namePath);
      },
      child: Container(
        width: 1.sw - 0.05.sw,
        height: hFrame,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.all(Radius.circular(hFrame * 0.05)),
        ),

        child: PaddingStyle(
          child: Row(
            children: [
              Icon(iconData, color: ColorConstant.primary, size: hFrame * 0.35),
              SizedBox(width: 0.05 * wFrame),
              TextGGStyle(title, 0.15 * hFrame, fontWeight: FontWeight.bold),
            ],
          ),
        ),
      ),
    );
  }
}
