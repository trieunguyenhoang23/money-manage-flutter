import 'package:flutter/material.dart';
import 'package:money_manage_flutter/export/router.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: appNavigatorKey,
    initialLocation: SplashRoutes.splashPath,
    routes: [
      ...SplashRoutes.routes,
      MainShellRoutes.mainRoutes,
      ...CategoryRoutes.routes,
    ],
  );
}
