import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/core/error/failure.dart';
import 'package:money_manage_flutter/export/core_external.dart';
import '../../../../../core/enum/transaction_type.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../data/datasource/sync/transaction_sync_key.dart';
import '../../data/datasource/sync/transaction_sync_store.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../repositories/transaction_repository.dart';

@LazySingleton()
class CreateTransactionUseCase {
  final TransactionRepository _repository;
  final TransactionSyncStore _transactionSyncStore;

  CreateTransactionUseCase(this._repository, this._transactionSyncStore);

  Future<Either<Failure, TransactionLocalModel>> execute({
    required double amount,
    required String note,
    required CategoryLocalModel category,
    required DateTime transactionAt,
    FilePicked? imageFile,
  }) async {
    final now = DateTime.now();

    TransactionLocalModel transaction = TransactionLocalModel(
      amount: amount,
      note: note,
      type: category.type ?? TransactionType.EXPENSE,
      categoryId: category.idServer!,
      transactionAt: transactionAt,
      createdAt: now,
      updatedAt: now,
      imageBytes: imageFile?.bytes,
      isSynced: false,
    );

    final result = await _repository.addTransaction(
      transaction: transaction,
      category: category,
      imageFile: imageFile,
    );

    result.fold((error) {}, (data) async {
      // Reset sync key
      final syncKey = TransactionSyncKey(
        year: transactionAt.year,
        month: transactionAt.month,
        type: null, // Reset tab ALL
      );

      // Reset end data
      await _transactionSyncStore.saveProgress(syncKey, end: false);
    });

    return result;
  }
}
