import 'dart:convert';

class CategoryAnalytics {
  final String id;
  final String name;
  final String type;
  final double totalAmount;
  final int transactionCount;
  final double percentage;

  CategoryAnalytics({
    required this.id,
    required this.name,
    required this.type,
    required this.totalAmount,
    required this.transactionCount,
    this.percentage = 0,
  });

  factory CategoryAnalytics.fromJson(Map<String, dynamic> json) {
    return CategoryAnalytics(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      transactionCount: json['transactionCount'] as int,
    );
  }

  CategoryAnalytics copyWith({
    String? id,
    String? name,
    String? type,
    double? totalAmount,
    int? transactionCount,
    double? percentage,
  }) {
    return CategoryAnalytics(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      totalAmount: totalAmount ?? this.totalAmount,
      transactionCount: transactionCount ?? this.transactionCount,
      percentage: percentage ?? this.percentage,
    );
  }

  static List<CategoryAnalytics> fromList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((item) => CategoryAnalytics.fromJson(item)).toList();
  }
}
