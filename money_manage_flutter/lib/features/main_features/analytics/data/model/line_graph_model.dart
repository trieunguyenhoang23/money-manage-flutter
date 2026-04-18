import 'package:fl_chart/fl_chart.dart';
import 'package:money_manage_flutter/core/extension/date_extension.dart';
import '../../../../../export/ui_external.dart';

class LineGraphModel {
  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;
  final List<FlSpot> balanceSpots;
  final Map<double, String> xLabels;
  final String groupType;
  final double maxY;
  final double minY;
  final double maxX;
  final double xInterval;
  final double yInterval;

  LineGraphModel({
    required this.incomeSpots,
    required this.expenseSpots,
    required this.balanceSpots,
    required this.xLabels,
    required this.groupType,
    required this.maxX,
    required this.maxY,
    required this.minY,
    required this.xInterval,
    required this.yInterval,
  });

  factory LineGraphModel.calculate({
    required List<FlSpot> incomeSpots,
    required List<FlSpot> expenseSpots,
    required List<FlSpot> balanceSpots,
    required String groupType,
    required double rawMaxY,
    required double rawMinY,
    required DateTimeRange range,
  }) {
    final double maxX = range.end.calculateXValue(range.start, groupType);

    /// Create Label
    final xLabels = <double, String>{};
    for (int i = 0; i <= maxX.toInt(); i++) {
      DateTime date;
      if (groupType == 'year') {
        date = DateTime(
          range.start.year + i,
          range.start.month,
          range.start.day,
        );
      } else if (groupType == 'month') {
        date = DateTime(range.start.year, range.start.month + i, 1);
      } else {
        date = range.start.add(Duration(days: i));
      }
      xLabels[i.toDouble()] = date.toGraphLabel(groupType);
    }

    /// Calculate Interval
    // Y
    final maxY = rawMaxY == 0 ? 100.0 : rawMaxY * 1.2;
    double minY = rawMinY < 0 ? rawMinY * 1.2 : 0;
    final yInterval = (maxY - minY) / 5;

    // X
    double xInterval = maxX > 5 ? (maxX / 5).floorToDouble() : 1.0;
    if (xInterval < 1) xInterval = 1;

    return LineGraphModel(
      incomeSpots: incomeSpots..sort((a, b) => a.x.compareTo(b.x)),
      expenseSpots: expenseSpots..sort((a, b) => a.x.compareTo(b.x)),
      balanceSpots: balanceSpots..sort((a, b) => a.x.compareTo(b.x)),
      xLabels: xLabels,
      groupType: groupType,
      maxY: maxY,
      minY: minY,
      maxX: maxX,
      xInterval: xInterval,
      yInterval: yInterval,
    );
  }
}
