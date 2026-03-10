import 'package:money_manage_flutter/export/ui_external.dart';

class SizeAppUtils {
  static final SizeAppUtils _singleton = SizeAppUtils._internal();

  factory SizeAppUtils() => _singleton;

  SizeAppUtils._internal();

  Size? size;

  bool get isTablet => isSmallTablet || isLargeTablet;

  bool get isSmallTablet => ((size?.shortestSide ?? 0) >= 600);

  bool get isPhone => ((size?.shortestSide ?? 0) < 600);

  bool get isLargeTablet => ((size?.shortestSide ?? 0) >= 720);

  double get wScreenWithPadding => 1.sw - 0.05.sw * 2;

  void getSizeApp(BuildContext context) {
    if (size != null) return;

    size = MediaQuery.sizeOf(context);
  }
}
