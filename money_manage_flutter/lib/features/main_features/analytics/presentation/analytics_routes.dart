import 'package:money_manage_flutter/export/router.dart';

class AnalyticRoutes {
  static const analyticName = 'analytic';
  static const analyticPath = '/analytic';

  static final routes = [
    GoRoute(
      path: analyticPath,
      name: analyticName,
      builder: (context, state) => const AnalyticsScreen(),
    ),
  ];
}
