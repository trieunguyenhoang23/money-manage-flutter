import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../export/ui_external.dart';
import '../../data/model/line_graph_model.dart';
import '../../data/model/overview_analytics_model.dart';
import '../../domain/usecase/get_overview_usecase.dart';
import 'date_range_provider.dart';

class OverviewGraphState {
  final LineGraphModel? graphModel;
  final OverviewAnalytics? overViewAnalytics;
  final String? error;

  OverviewGraphState({this.graphModel, this.overViewAnalytics, this.error});
}

class OverviewGraphNotifier extends AsyncNotifier<OverviewGraphState> {
  @override
  FutureOr<OverviewGraphState> build() async {
    final range = ref.watch(dateRangeProvider);
    final result = await getIt<GetOverviewUseCase>().execute(
      range.start,
      range.end,
    );

    return result.fold((error) => OverviewGraphState(error: error.toString()), (
      data,
    ) {
      final List<FlSpot> incomeSpots = [];
      final List<FlSpot> expenseSpots = [];
      final List<FlSpot> balanceSpots = [];
      double currentMaxY = 0;

      for (final point in data.points) {
        final double x = _calculateXValue(
          point.label,
          range.start,
          data.groupType,
        );

        incomeSpots.add(FlSpot(x, point.income));
        expenseSpots.add(FlSpot(x, point.expense));
        balanceSpots.add(FlSpot(x, point.balance));

        final highest = [
          point.income,
          point.expense,
          point.balance,
        ].reduce((a, b) => a > b ? a : b);
        if (highest > currentMaxY) currentMaxY = highest;
      }

      final graphModel = LineGraphModel(
        incomeSpots: incomeSpots..sort((a, b) => a.x.compareTo(b.x)),
        expenseSpots: expenseSpots..sort((a, b) => a.x.compareTo(b.x)),
        balanceSpots: balanceSpots..sort((a, b) => a.x.compareTo(b.x)),
        xLabels: [],
        groupType: data.groupType,
        maxY: currentMaxY == 0 ? 100 : currentMaxY * 1.2,
      );

      return OverviewGraphState(
        graphModel: graphModel,
        overViewAnalytics: data,
      );
    });
  }

  double _calculateXValue(String label, DateTime start, String groupType) {
    final date = DateTime.parse(groupType == 'month' ? "$label-01" : label);
    if (groupType == 'month') {
      return ((date.year - start.year) * 12 + (date.month - start.month))
          .toDouble();
    }
    return date
        .difference(DateTime(start.year, start.month, start.day))
        .inDays
        .toDouble();
  }
}

final overviewGraphProvider =
    AsyncNotifierProvider.autoDispose<OverviewGraphNotifier, OverviewGraphState>(
      () => OverviewGraphNotifier(),
    );
