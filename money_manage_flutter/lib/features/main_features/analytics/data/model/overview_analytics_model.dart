class OverviewAnalytics {
  final String groupType; // 'day', 'month', or 'year'
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

  OverviewPoint({
    required this.label,
    required this.income,
    required this.expense,
    required this.balance,
  });

  factory OverviewPoint.fromJson(Map<String, dynamic> json) {
    return OverviewPoint(
      label: json['label'],
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'income': income,
    'expense': expense,
    'balance': balance,
  };
}
