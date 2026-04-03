import 'package:fl_chart/fl_chart.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../../profile/presentation/provider/currency_provider.dart';
import '../../../data/model/line_graph_model.dart';
import '../../provider/date_range_provider.dart';
import '../../provider/overview_analytics_provider.dart';

class OverviewLineGraphWidget extends ConsumerWidget {
  const OverviewLineGraphWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(dateRangeProvider);
    final overviewGraphState = ref.watch(overviewGraphProvider);
    final currencyCode = ref.read(currencyProvider);

    return overviewGraphState.when(
      loading: () => const LoadingWidget(),
      error: (err, _) => Center(child: TextGGStyle("Error: $err", 14)),
      data: (data) {
        if (data.error != null) {
          return Center(child: TextGGStyle(data.error!, 0.05.sw));
        }

        if (data.graphModel == null) return const SizedBox.shrink();

        LineGraphModel lineGraphModel = data.graphModel!;

        // Calculate the full width of the X-axis
        final double maxX = _calculateMaxX(range, lineGraphModel.groupType);

        return AspectRatio(
          aspectRatio: 1.7,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: maxX,
              minY: 0,
              maxY: lineGraphModel.maxY,
              gridData: _buildGridData(lineGraphModel.maxY),
              borderData: FlBorderData(show: false),
              titlesData: _buildTitles(
                context,
                range,
                lineGraphModel.groupType,
                lineGraphModel.maxY,
                maxX,
                currencyCode.value ?? 'VND',
              ),
              lineBarsData: [
                _lineData(
                  lineGraphModel.balanceSpots,
                  ColorConstant.warning500,
                  3,
                  true,
                  context,
                ),
                _lineData(
                  lineGraphModel.incomeSpots,
                  ColorConstant.success500,
                  2,
                  false,
                  context,
                ),
                _lineData(
                  lineGraphModel.expenseSpots,
                  ColorConstant.error500,
                  2,
                  false,
                  context,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _calculateMaxX(DateTimeRange range, String groupType) {
    if (groupType == 'month') {
      return ((range.end.year - range.start.year) * 12 +
              (range.end.month - range.start.month))
          .toDouble();
    }
    return range.end.difference(range.start).inDays.toDouble();
  }

  FlTitlesData _buildTitles(
    BuildContext context,
    DateTimeRange range,
    String groupType,
    double maxY,
    double maxX,
    String currencyCode,
  ) {
    // The Secret Sauce: Dynamic Interval
    // If maxX is 12 (months), interval 2.4 ensures ~5-6 labels.
    final double xInterval = maxX > 0 ? maxX / 5 : 1.0;

    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        axisNameWidget: TextGGStyle(
          "($currencyCode)",
          0.02.sw,
          color: Colors.grey,
        ),
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: maxY / 5,
          getTitlesWidget: (val, _) =>
              TextGGStyle(StringUtils.formatYAxis(val), 0.025.sw, maxLines: 1),
        ),
      ),
      bottomTitles: AxisTitles(
        axisNameWidget: TextGGStyle(
          groupType.toUpperCase(),
          0.02.sw,
          color: Colors.grey,
        ),
        sideTitles: SideTitles(
          showTitles: true,
          interval: xInterval, // limits the labels to ~6
          getTitlesWidget: (val, _) {
            // Logic to find the date for this specific X coordinate
            final date = groupType == 'month'
                ? DateTime(range.start.year, range.start.month + val.toInt())
                : range.start.add(Duration(days: val.toInt()));

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                groupType == 'month'
                    ? "${date.month}/${date.year % 100}"
                    : "${date.day}/${date.month}",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  FlGridData _buildGridData(double maxY) {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: maxY / 5,
      getDrawingHorizontalLine: (val) =>
          FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
    );
  }

  LineChartBarData _lineData(
    List<FlSpot> spots,
    Color color,
    double width,
    bool filled,
    BuildContext context,
  ) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.5,
      color: color,
      barWidth: width,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: filled,
        color: color.withValues(alpha: 0.1),
      ),
    );
  }
}
