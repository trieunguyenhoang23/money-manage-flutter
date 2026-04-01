import 'dart:convert';

class CategoryAnalytics {
  final String id;
  final String name;
  final String type;
  final double totalAmount;
  final int transactionCount;

  CategoryAnalytics({
    required this.id,
    required this.name,
    required this.type,
    required this.totalAmount,
    required this.transactionCount,
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

  static List<CategoryAnalytics> fromList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((item) => CategoryAnalytics.fromJson(item)).toList();
  }
}
