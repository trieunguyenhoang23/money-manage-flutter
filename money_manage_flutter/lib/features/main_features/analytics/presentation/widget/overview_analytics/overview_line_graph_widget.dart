import 'package:fl_chart/fl_chart.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../../profile/presentation/provider/currency_provider.dart';
import '../../../data/model/line_graph_model.dart';
import '../../provider/overview_analytics_provider.dart';

class OverviewLineGraphWidget extends ConsumerWidget {
  const OverviewLineGraphWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

        return LineGraphContent(
          model: data.graphModel!,
          currency: currencyCode.value ?? 'VND',
        );
      },
    );
  }
}

/// Primary display graph
class LineGraphContent extends StatelessWidget {
  final LineGraphModel model;
  final String currency;

  const LineGraphContent({
    super.key,
    required this.model,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: model.maxX,
          minY: 0,
          maxY: model.maxY,
          // Draw horizontal reference grid lines
          gridData: _buildGridData(model.maxY),
          borderData: FlBorderData(show: false),
          titlesData: GraphTitlesConfig.build(model, currency),

          /// Draw line Balance, Income, Expense
          lineBarsData: [
            _LineBar(
              spots: model.balanceSpots,
              color: ColorConstant.warning500,
              width: 3,
              filled: true,
            ),
            _LineBar(
              spots: model.incomeSpots,
              color: ColorConstant.success500,
              width: 2,
            ),
            _LineBar(
              spots: model.expenseSpots,
              color: ColorConstant.error500,
              width: 2,
            ),
          ],
        ),
      ),
    );
  }

  FlGridData _buildGridData(double maxY) {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      // Divide Y-axis into 5 equal segments
      horizontalInterval: maxY / 5,
      getDrawingHorizontalLine: (val) => FlLine(
        color: ColorConstant.neutral200.withValues(alpha: 0.1),
        strokeWidth: 1,
      ),
    );
  }
}

/// Display line graph for Balance, Income, Expense
class _LineBar extends LineChartBarData {
  _LineBar({
    required super.spots,
    required Color super.color,
    double width = 2,
    bool filled = false,
  }) : super(
         curveSmoothness: 0.5,
         barWidth: width,
         dotData: const FlDotData(show: false),
         belowBarData: BarAreaData(
           show: filled,
           color: color.withValues(alpha: 0.1),
         ),
       );
}

/// Configuration Titles for axis
class GraphTitlesConfig {
  static FlTitlesData build(LineGraphModel model, String currency) {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

      /// Y - axis
      leftTitles: AxisTitles(
        axisNameWidget: TextGGStyle(
          "($currency)",
          0.02.sw,
          color: ColorConstant.neutral200,
        ),
        sideTitles: SideTitles(
          showTitles: true,
          // Space reserved for Y-axis labels
          reservedSize: 40,
          interval: model.yInterval,
          getTitlesWidget: (val, _) =>
              TextGGStyle(StringUtils.formatYAxis(val), 0.025.sw),
        ),
      ),

      /// X - axis
      bottomTitles: AxisTitles(
        axisNameWidget: TextGGStyle(
          model.groupType.toUpperCase(),
          0.02.sw,
          color: ColorConstant.neutral200,
        ),
        sideTitles: SideTitles(
          showTitles: true,
          interval: model.xInterval,
          getTitlesWidget: (val, _) {
            final key = val.round().toDouble();
            final label = model.xLabels[key] ?? '';

            return Padding(
              padding: EdgeInsets.only(top: 0.01.sh.clamp(5, 10)),
              child: TextGGStyle(label, 0.03.sw.clamp(7, 11)),
            );
          },
        ),
      ),
    );
  }
}
