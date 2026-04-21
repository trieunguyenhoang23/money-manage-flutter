import '../../../../../../core/enum/transaction_type.dart';

class TransactionRemoteModel {
  final String? id;
  final TransactionType type;
  final double amount;
  final String currency;
  final String note;
  final String imageDescription;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final String categoryId;
  final String? reminderId;

  TransactionRemoteModel({
    this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.note,
    required this.imageDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.categoryId,
    this.reminderId,
  });
}
