import 'package:money_manage_flutter/export/ui_external.dart';

class ThumbnailLocalWidget extends StatelessWidget {
  final double w;
  final double h;
  final double radius;
  final dynamic imgUrl;
  final bool isSkinPack;
  final BorderRadius? borderRadius;
  final BoxFit? boxFit;

  const ThumbnailLocalWidget({
    super.key,
    required this.w,
    required this.h,
    required this.imgUrl,
    required this.radius,
    this.borderRadius,
    this.isSkinPack = false,
    this.boxFit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(radius)),
      ),
      clipBehavior: Clip.hardEdge,
      child: imgUrl is String
          ? Image.asset(
              width: w,
              height: h,
              imgUrl,
              fit: boxFit,
              filterQuality: FilterQuality.none,
              gaplessPlayback: true,
            )
          : Image.memory(
              imgUrl,
              width: w,
              height: h,
              fit: boxFit,
              filterQuality: FilterQuality.none,
              gaplessPlayback: true,
            ),
    );
  }
}
