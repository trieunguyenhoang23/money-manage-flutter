import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constant/color_constant.dart';
import '../../../export/ui_external.dart';

class BtnAppbarWidget extends StatelessWidget {
  final String icPath;
  final Widget? widget;
  final bool isActionButton;
  final double? customSize; // Thêm biến này để linh hoạt hơn nếu muốn
  final Function() onTap;

  const BtnAppbarWidget({
    super.key,
    this.icPath = '',
    this.widget,
    required this.onTap,
    this.isActionButton = false,
    this.customSize,
  });

  @override
  Widget build(BuildContext context) {
    double icSize = customSize ?? (20 / 812).sh.clamp(20, 50);

    bool isLottieFile = icPath.toLowerCase().endsWith('.json');
    bool isSvgFile = icPath.toLowerCase().endsWith('.svg');

    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: icSize,
        height: icSize,
        child: isLottieFile
            ? RepaintBoundary(
                child: Lottie.asset(
                  icPath,
                  width: icSize,
                  height: icSize,
                  fit: BoxFit.contain,
                ),
              )
            : widget ??
                  (isSvgFile
                      ? SvgPicture.asset(
                          icPath,
                          width: icSize,
                          height: icSize,
                          colorFilter: const ColorFilter.mode(
                            ColorConstant.primary,
                            BlendMode.srcIn,
                          ),
                        )
                      : Image.asset(
                          icPath,
                          width: icSize,
                          height: icSize,
                          color: ColorConstant.primary,
                        )),
      ),
    );
  }
}
