import 'package:fl_chart/fl_chart.dart';

class LineGraphModel {
  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;
  final List<FlSpot> balanceSpots;
  final List<String> xLabels;
  final String groupType;
  final double maxY;

  LineGraphModel({
    required this.incomeSpots,
    required this.expenseSpots,
    required this.balanceSpots,
    required this.xLabels,
    required this.groupType,
    required this.maxY,
  });
}
