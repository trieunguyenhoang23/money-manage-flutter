import 'package:money_manage_flutter/export/router.dart';

class SplashRoutes {
  static const splashPath = '/splash';
  static const splashName = 'splash';

  static final routes = [
    GoRoute(
      path: splashPath,
      name: splashName,
      builder: (context, state) => const SplashScreen(),
    ),
  ];
}
