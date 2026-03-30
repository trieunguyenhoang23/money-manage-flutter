import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/enum/transaction_type.dart';

part 'category_local_model.g.dart';

@collection
class CategoryLocalModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? idServer;

  String? name;
  String? description;

  @Enumerated(EnumType.name)
  TransactionType? type;

  DateTime? createdAt;
  DateTime? updatedAt;
  String? userId;
  bool isSynced;

  CategoryLocalModel({
    String? idServer,
    this.name,
    this.description,
    this.type = TransactionType.EXPENSE,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.isSynced = false,
  }) : idServer = idServer ?? const Uuid().v4();

  // Factory to map from Remote Data (API)
  factory CategoryLocalModel.fromRemote(Map<String, dynamic> remote) {
    return CategoryLocalModel(
      idServer: remote['id'],
      name: remote['name'],
      description: remote['description'],
      type: _parseTransactionType(remote['type']),
      createdAt: remote['created_at'] != null
          ? DateTime.tryParse(remote['created_at'])?.toLocal()
          : null,
      updatedAt: remote['updated_at'] != null
          ? DateTime.tryParse(remote['updated_at'])?.toLocal()
          : null,
      userId: remote['user_id'],
      isSynced: false, // Data from server is synced by default
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

  // Use when posting local data to server
  Map<String, dynamic> toJson() {
    return {
      'id': idServer,
      'name': name,
      'description': description,
      'type': type?.name,
      'created_at': createdAt?.toUtc().toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt?.toUtc().toIso8601String(),
    };
  }

  Map<String, dynamic> toUpdateJson({
    required String nameTemp,
    required String descTemp,
    required TransactionType typeTemp,
  }) {
    final Map<String, dynamic> patch = {};

    if (nameTemp != name) {
      patch['name'] = nameTemp;
    }

    if (descTemp != description) {
      patch['description'] = descTemp;
    }

    if (typeTemp != type) {
      patch['type'] = typeTemp.name;
    }

    patch['updated_at'] = DateTime.now().toIso8601String();

    return patch;
  }

  // Update logic similar to TransactionLocalModel
  bool merge({
    String? newName,
    String? newDescription,
    TransactionType? newType,
  }) {
    bool hasChanged = false;

    if (newName != null && name != newName) {
      name = newName;
      hasChanged = true;
    }

    if (newDescription != null && description != newDescription) {
      description = newDescription;
      hasChanged = true;
    }

    if (newType != null && type != newType) {
      type = newType;
      hasChanged = true;
    }

    if (hasChanged) {
      updatedAt = DateTime.now();
      isSynced = false; // Mark dirty for sync
    }

    return hasChanged;
  }
}
