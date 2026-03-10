import '../../../domain/enums/transaction_type.dart';

class TransactionRemoteModel {
  final String? id;
  final TransactionType type;
  final double amount;
  final String currency;
  final String note;
  final DateTime transactionDate;
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
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.categoryId,
    this.reminderId,
  });

  // Manual copyWith
  TransactionRemoteModel copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    // ... add others
  }) {
    return TransactionRemoteModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency,
      // etc.
      note: note,
      transactionDate: transactionDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userId: userId,
      categoryId: categoryId,
    );
  }
}
