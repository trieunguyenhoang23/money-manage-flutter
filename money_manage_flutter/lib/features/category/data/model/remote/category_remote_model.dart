import 'package:money_manage_flutter/features/main_features/transactions/domain/enums/transaction_type.dart';

import '../local/category_local_model.dart';

class CategoryRemoteModel {
  final String? id;
  final String name;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final TransactionType? type;
  final String? userId;

  CategoryRemoteModel({
    this.id,
    required this.name,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.type,
  });

  factory CategoryRemoteModel.fromJson(Map<String, dynamic> json) {
    return CategoryRemoteModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      userId: json['user_id'] as String? ?? '',
      type: json['type'] != null
          ? TransactionType.values.byName(json['type'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user_id': userId,
      'type': type?.name,
    };
  }

  CategoryLocalModel toLocalModel({required bool isSynced}) {
    return CategoryLocalModel()
      ..name = name
      ..description = description
      ..createdAt = createdAt ?? DateTime.now()
      ..updatedAt = updatedAt
      ..userId = userId
      ..type = type
      ..isSynced = isSynced;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryRemoteModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
