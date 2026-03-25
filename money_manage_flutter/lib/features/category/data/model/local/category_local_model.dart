import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/enum/transaction_type.dart';
part 'category_local_model.g.dart';

@collection
class CategoryLocalModel {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  String idServer = const Uuid().v4();
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  @Enumerated(EnumType.name)
  TransactionType? type;
  String? userId;
  bool isSynced = false;

  CategoryLocalModel();

  // Use when post local data to server
  Map<String, dynamic> toJson() {
    return {
      'id': idServer,
      'name': name,
      'description': description,
      'created_at': createdAt?.toUtc().toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt?.toUtc().toIso8601String(),
      'type': type?.name,
    };
  }

  factory CategoryLocalModel.fromJson(Map<String, dynamic> json) {
    return CategoryLocalModel()
      ..idServer =
          json['id'] ??
          const Uuid()
              .v4() // Use server ID
      ..name = json['name']
      ..description = json['description']
      ..createdAt = json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])?.toLocal()
          : null
      ..updatedAt = json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])?.toLocal()
          : null
      ..type = json['type'] is TransactionType
          ? json['type']
          : TransactionType.values.byName(json['type'] ?? 'EXPENSE')
      ..isSynced = true; // Data from server is by definition synced
  }
}
