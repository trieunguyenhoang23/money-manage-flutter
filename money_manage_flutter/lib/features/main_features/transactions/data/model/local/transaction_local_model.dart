import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../core/enum/transaction_type.dart';
import '../../../../../category/data/model/local/category_local_model.dart';

part 'transaction_local_model.g.dart';

@collection
class TransactionLocalModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? idServer;

  @Enumerated(EnumType.name)
  TransactionType type;
  double amount;
  String note;
  String? imageUrl;
  List<int>? imageBytes;
  DateTime transactionAt;
  DateTime createdAt;
  DateTime updatedAt;
  String? userId;
  String categoryId;

  final category = IsarLink<CategoryLocalModel>();

  String? reminderId;
  bool isSynced;

  TransactionLocalModel({
    this.idServer,
    this.type = TransactionType.EXPENSE,
    this.amount = 0.0,
    this.note = '',
    this.imageUrl,
    this.imageBytes,
    required this.transactionAt,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.categoryId = '',
    this.reminderId,
    this.isSynced = false,
  }) {
    idServer ??= const Uuid().v4();
  }

  factory TransactionLocalModel.fromRemote(Map<String, dynamic> remote) {
    return TransactionLocalModel(
      idServer: remote['id'],
      type: _parseTransactionType(remote['type']),
      amount: (remote['amount'] as num?)?.toDouble() ?? 0.0,
      note: remote['note'] ?? '',
      imageUrl: remote['image_description'],
      transactionAt: DateTime.parse(remote['transaction_at']),
      createdAt: DateTime.parse(remote['created_at']),
      updatedAt: DateTime.parse(remote['updated_at']),
      userId: remote['user_id'],
      categoryId: remote['category_id'] ?? '',
      reminderId: remote['reminder_id'],
      isSynced: true,
    );
  }

  static TransactionType _parseTransactionType(dynamic type) {
    if (type is TransactionType) return type;
    if (type is String) {
      return TransactionType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => TransactionType.EXPENSE,
      );
    }
    return TransactionType.EXPENSE;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idServer,
      'type': type.name,
      'amount': amount,
      'note': note,
      'transaction_at': transactionAt.toUtc().toIso8601String(),
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'category_id': categoryId,
      'reminder_id': reminderId,
    };
  }

  Map<String, dynamic> toUpdateJson({
    required double amountTemp,
    required String noteTemp,
    required CategoryLocalModel cateTemp,
    required DateTime transactionAtTemp,
  }) {
    final Map<String, dynamic> patch = {};

    if (amountTemp != amount) {
      patch['amount'] = amountTemp;
    }
    if (noteTemp != note) patch['note'] = noteTemp;
    if (cateTemp.idServer != category.value?.idServer) {
      patch['category_id'] = cateTemp.idServer;
      patch['type'] = cateTemp.type?.name;
    }
    if (transactionAtTemp != transactionAt) {
      patch['transaction_at'] = transactionAtTemp.toIso8601String();
    }

    patch['updated_at'] = DateTime.now().toIso8601String();
    return patch;
  }

  bool merge({
    required double amountTemp,
    required String noteTemp,
    required CategoryLocalModel cateTemp,
    required DateTime transactionAtTemp,
    List<int>? newImageBytes,
    String? newImageUrl,
  }) {
    bool hasChanged = false;

    if (amount != amountTemp) {
      amount = amountTemp;
      hasChanged = true;
    }

    if (note != noteTemp) {
      note = noteTemp;
      hasChanged = true;
    }

    if (transactionAt != transactionAtTemp) {
      transactionAt = transactionAtTemp;
      hasChanged = true;
    }

    if (category.value?.idServer != cateTemp.idServer) {
      category.value = cateTemp;
      categoryId = cateTemp.idServer ?? '';
      type = cateTemp.type ?? TransactionType.EXPENSE;
      hasChanged = true;
    }

    if (newImageBytes != null) {
      imageBytes = newImageBytes;
      imageUrl = null;
      hasChanged = true;
    } else if (newImageUrl != null && imageUrl != newImageUrl) {
      imageUrl = newImageUrl;
      imageBytes = null;
      hasChanged = true;
    }

    if (hasChanged) {
      updatedAt = DateTime.now();
      isSynced = false; // Mark as dirty so sync knows to upload
    }

    return hasChanged;
  }
}
