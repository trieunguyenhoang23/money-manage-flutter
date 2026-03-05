import 'package:money_manage_flutter/export/router.dart';

class ProfileRoutes {
  static const profilePath = '/profile';
  static const profileName = 'profile';

  static final routes = [
    GoRoute(
      path: profilePath,
      name: profileName,
      builder: (context, state) => const ProfileScreen(),
    ),
  ];
}
