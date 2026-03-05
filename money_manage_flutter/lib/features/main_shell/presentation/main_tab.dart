import 'package:money_manage_flutter/core/extension/context_extension.dart';

import '../../../export/ui_external.dart';

class BottomTabBar {
  ///String Icon Path or IconData
  final dynamic icon;
  final String Function(BuildContext) label;

  BottomTabBar({required this.icon, required this.label});
}

final bottomTabBars = [
  BottomTabBar(
    icon: Icons.monetization_on,
    label: (context) => context.lang.transaction,
  ),
  BottomTabBar(
    icon: Icons.data_exploration,
    label: (context) => context.lang.analytics,
  ),
  BottomTabBar(icon: Icons.person, label: (context) => context.lang.profile),
];
