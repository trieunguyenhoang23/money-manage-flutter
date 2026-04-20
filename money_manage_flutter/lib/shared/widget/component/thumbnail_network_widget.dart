import 'package:extended_image/extended_image.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';

class ThumbnailNetworkWidget extends StatelessWidget {
  final double w;
  final double h;
  final double radius;
  final String imgUrl;
  final bool isShowShadow;
  final BoxFit? boxFit;

  const ThumbnailNetworkWidget({
    super.key,
    required this.w,
    required this.h,
    required this.imgUrl,
    required this.radius,
    this.boxFit,
    this.isShowShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: isShowShadow
            ? [shadowStyle(Colors.black12, const Offset(0, 2), 5)]
            : null,
      ),
      clipBehavior: Clip.hardEdge,
      child: ExtendedImage.network(
        imgUrl,
        cache: true,
        width: w,
        height: h,
        fit: boxFit ?? BoxFit.cover,
        // TRUE is free up buffers immediately
        clearMemoryCacheWhenDispose: true,
        // avoid keeping "broken" image placeholders in RAM
        clearMemoryCacheIfFailed: true,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return const LoadingWidget();
            case LoadState.failed:
              return const Icon(Icons.error);
            case LoadState.completed:
              return null;
          }
        },
      ),
    );
  }
}
