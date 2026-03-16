import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/features/category/data/model/local/category_local_model.dart';
import '../../../../../../core/enum/transaction_type.dart';

part 'transaction_local_model.g.dart';

@collection
class TransactionLocalModel {
  // Isar local auto-increment ID
  Id id = Isar.autoIncrement;

  // The UUID from your Server/Remote model
  @Index(unique: true, replace: true)
  String? idServer;

  @Enumerated(EnumType.name)
  late TransactionType type;

  late double amount;
  late String currency;
  late String note;
  late String imageDescription;
  late DateTime createdAt;
  late DateTime updatedAt;
  late String userId;
  late String categoryId;
  final category = IsarLink<CategoryLocalModel>();
  String? reminderId;
  bool isSynced = false;

  TransactionLocalModel();

  factory TransactionLocalModel.fromRemote(dynamic remote) {
    return TransactionLocalModel()
      ..idServer = remote.id
      ..type = remote.type
      ..amount = remote.amount
      ..currency = remote.currency
      ..note = remote.note
      ..imageDescription = remote.transactionDate
      ..createdAt = remote.createdAt
      ..updatedAt = remote.updatedAt
      ..userId = remote.userId
      ..categoryId = remote.categoryId
      ..reminderId = remote.reminderId
      ..isSynced = true;
  }

  // Syncing back to server
  Map<String, dynamic> toJson() {
    return {
      'id': idServer,
      'type': type.name,
      'amount': amount,
      'currency': currency,
      'note': note,
      'image_description': imageDescription,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'user_id': userId,
      'category_id': categoryId,
      'reminder_id': reminderId,
    };
  }
}
