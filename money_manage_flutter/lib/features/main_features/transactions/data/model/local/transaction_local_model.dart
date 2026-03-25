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
  String currency;
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
    this.currency = 'VND',
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

  // Factory để map từ Remote Data (API)
  factory TransactionLocalModel.fromRemote(dynamic remote) {
    return TransactionLocalModel(
      idServer: remote.id,
      type: remote.type is String
          ? TransactionType.values.byName(remote.type)
          : remote.type,
      amount: (remote.amount as num).toDouble(),
      currency: remote.currency ?? 'VND',
      note: remote.note ?? '',
      imageUrl: remote.imageUrl,
      transactionAt: DateTime.parse(remote.transactionAt),
      createdAt: remote.cDateTime.parse(remote.createdAt),
      updatedAt: remote.uDateTime.parse(remote.updatedAt),
      userId: remote.userId,
      categoryId: remote.categoryId ?? '',
      reminderId: remote.reminderId,
      isSynced: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idServer,
      'type': type.name,
      'amount': amount,
      'currency': currency,
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
      patch['type'] = cateTemp.type;
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
