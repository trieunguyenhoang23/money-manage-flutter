class OverviewAnalytics {
  final String groupType;
  final List<OverviewPoint> points;

  OverviewAnalytics({required this.groupType, required this.points});

  factory OverviewAnalytics.fromJson(Map<String, dynamic> json) {
    return OverviewAnalytics(
      groupType: json['groupType'],
      points: (json['data'] as List)
          .map((item) => OverviewPoint.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'groupType': groupType,
    'data': points.map((point) => point.toJson()).toList(),
  };
}

class OverviewPoint {
  final String label;
  final double income;
  final double expense;
  final double balance;
  final TrendingPattern trend;

  OverviewPoint({
    required this.label,
    required this.income,
    required this.expense,
    required this.balance,
    required this.trend,
  });

  factory OverviewPoint.fromJson(Map<String, dynamic> json) {
    return OverviewPoint(
      label: json['label'],
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      trend: TrendingPattern.fromDynamic(json['trend']),
    );
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'income': income,
    'expense': expense,
    'balance': balance,
    'trend': trend.name,
  };

  static TrendingPattern identifyTrend(double current, double previous) {
    if (current > previous) return TrendingPattern.up;
    if (current < previous) return TrendingPattern.down;
    return TrendingPattern.flatten;
  }
}

enum TrendingPattern {
  up,
  down,
  flatten,
  none;

  static TrendingPattern fromDynamic(dynamic value) {
    if (value is TrendingPattern) return value;

    if (value is String) {
      return TrendingPattern.values.firstWhere(
        (e) => e.name.toUpperCase() == value.toUpperCase(),
        orElse: () => TrendingPattern.flatten,
      );
    }

    return TrendingPattern.flatten;
  }
}
