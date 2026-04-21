import 'package:money_manage_flutter/core/router/app_router.dart';
import 'package:money_manage_flutter/export/router.dart';

class ProfileRoutes {
  static const profilePath = '/profile';
  static const profileName = 'profile';

  static const languagePath = '/language';
  static const languageName = 'language';

  static final routes = [
    GoRoute(
      path: profilePath,
      name: profileName,
      builder: (context, state) => const ProfileScreen(),
      routes: [
        GoRoute(
          path: languagePath,
          name: languageName,
          parentNavigatorKey: appNavigatorKey,
          builder: (context, state) => const LanguageScreen(),
        ),
      ],
    ),
  ];
}
