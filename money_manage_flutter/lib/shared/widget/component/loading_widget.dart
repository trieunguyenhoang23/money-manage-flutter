import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/core.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RepaintBoundary(
        child: LoadingAnimationWidget.horizontalRotatingDots(
          color: ColorConstant.primary,
          size: 0.05.sw,
        ),
      ),
    );
  }
}
