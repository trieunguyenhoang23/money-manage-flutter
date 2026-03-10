import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constant/color_constant.dart';
import '../../../export/ui_external.dart';

class BtnAppbarWidget extends StatelessWidget {
  final String icPath;
  final Widget? widget;
  final bool isActionButton;
  final Function() onTap;

  const BtnAppbarWidget({
    super.key,
     this.icPath = '',
    this.widget,
    required this.onTap,
    this.isActionButton = false,
  });

  @override
  Widget build(BuildContext context) {
    double icSize = (20 / 812).sh.clamp(20, 50);
    bool isLottieFile = icPath.toLowerCase().endsWith('.json');
    bool isSvgFile = icPath.toLowerCase().endsWith('.svg');

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: icSize,
        height: icSize,
        child: isLottieFile
            ? RepaintBoundary(child: Lottie.asset(icPath))
            : widget ??
                  (isSvgFile
                      ? SvgPicture.asset(
                          icPath,
                          colorFilter: const ColorFilter.mode(
                            ColorConstant.primary,
                            BlendMode.srcIn,
                          ),
                        )
                      : Image.asset(icPath, color: ColorConstant.primary)),
      ),
    );
  }
}
