import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_manage_flutter/export/core.dart';
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

    return result.fold(
      (error) => OverviewGraphState(error: error.toString()),
      (data) => _mapToState(data, range),
    );
  }

  OverviewGraphState _mapToState(OverviewAnalytics data, DateTimeRange range) {
    final incomeSpots = <FlSpot>[];
    final expenseSpots = <FlSpot>[];
    final balanceSpots = <FlSpot>[];
    double currentMaxY = 0;

    for (final point in data.points) {
      // 1. Calculate axis-X
      final date = DateTime.tryParse(point.label);

      if (date == null) continue;
      final x = date.calculateXValue(range.start, data.groupType);

      // 2. Add coordinate
      incomeSpots.add(FlSpot(x, point.income));
      expenseSpots.add(FlSpot(x, point.expense));
      balanceSpots.add(FlSpot(x, point.balance));

      // 3. Up date MaxY (Padding 20%)
      currentMaxY = [
        currentMaxY,
        point.income,
        point.expense,
        point.balance,
      ].reduce((a, b) => a > b ? a : b);
    }

    return OverviewGraphState(
      graphModel: LineGraphModel.calculate(
        incomeSpots: incomeSpots,
        expenseSpots: expenseSpots,
        balanceSpots: balanceSpots,
        range: range,
        groupType: data.groupType,
        rawMaxY: currentMaxY,
      ),
      overViewAnalytics: data,
    );
  }
}

final overviewGraphProvider =
    AsyncNotifierProvider.autoDispose<
      OverviewGraphNotifier,
      OverviewGraphState
    >(() => OverviewGraphNotifier());
