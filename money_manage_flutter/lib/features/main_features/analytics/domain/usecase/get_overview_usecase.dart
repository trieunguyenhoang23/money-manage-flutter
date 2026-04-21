import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../data/model/overview_analytics_model.dart';
import '../repositories/analytics_repository.dart';

@LazySingleton()
class GetOverviewUseCase {
  final AnalyticsRepository _analyticsRepository;

  GetOverviewUseCase(this._analyticsRepository);

  Future<Either<Failure, OverviewAnalytics>> execute(
    DateTime startDate,
    DateTime endDate,
  ) async {
    /// Standardization range time
    final startStandardization = startDate.formatStartOfDay!;
    final endStandardization = endDate.formatEndOfDay!;

    final diffInDays = endStandardization
        .difference(startStandardization)
        .inDays;
    final groupBy = _determineGroupBy(diffInDays);

    final cumulativeData = await _analyticsRepository.getOverviewAnalytics(
      startStandardization,
      endStandardization,
      groupBy,
    );

    return cumulativeData.map((json) {
      final List<dynamic> rawData = json['data'];
      final List<OverviewPoint> points = [];

      for (int i = 0; i < rawData.length; i++) {
        final current = rawData[i];

        // Calculate cumulative balance
        double currentIncome =
            double.tryParse(current['income'].toString()) ?? 0;
        double currentExpense =
            double.tryParse(current['expense'].toString()) ?? 0;
        final double currentBalance = currentIncome - currentExpense;

        // Identify trend (compare Pn && Pn-1, P1 = TrendingPattern.none)
        TrendingPattern trend = i == 0
            ? TrendingPattern.none
            : OverviewPoint.identifyTrend(
                currentBalance,
                points[i - 1].balance,
              );

        points.add(
          OverviewPoint(
            label: current['label'],
            income: currentIncome,
            expense: currentExpense,
            balance: currentBalance,
            trend: trend,
          ),
        );
      }

      return OverviewAnalytics(groupType: groupBy, points: points);
    });
  }

  String _determineGroupBy(int days) {
    if (days <= 31) return 'day';
    if (days <= 900) return 'month';
    return 'year';
  }
}
