import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/features/category/data/model/remote/category_remote_model.dart';
import '../../../../main_features/transactions/domain/enums/transaction_type.dart';

part 'category_local_model.g.dart';

@collection
class CategoryLocalModel {
  Id id = Isar.autoIncrement;
  String? idServer;
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  @Enumerated(EnumType.name)
  TransactionType? type;
  String? userId;
  bool isSynced = false;

  // Use when post local data to server
  Map<String, dynamic> toJson(String userId) {
    return {
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
      'type': type?.name,
    };
  }
}
