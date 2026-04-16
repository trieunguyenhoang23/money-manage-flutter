import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../data/model/local/transaction_local_model.dart';

abstract class TransactionRepository {
  Future<List<TransactionLocalModel>> getLocalTransactions({
    required int page,
    required int month,
    required int year,
    TransactionType? type,
    required int limit,
  });

  Future<Either<Failure, List<TransactionLocalModel>>>
  fetchAndSaveRemoteTransactions({
    required int page,
    required int month,
    required int year,
    TransactionType? type,
    required int limit,
  });

  Future<List<CategoryLocalModel>> getCategoryThroughTrans(
    TransactionType type,
    int range,
  );

  Future<Either<Failure, TransactionLocalModel>> addTransaction({
    required TransactionLocalModel transaction,
    required CategoryLocalModel category,
    FilePicked? imageFile,
  });

  Future<Either<Failure, TransactionLocalModel>> updateTransaction({
    required Map<String, dynamic> updateJsonRequestBody,
    required TransactionLocalModel oldItem,
    required CategoryLocalModel newCate,
    required bool isDeleteImg,
    FilePicked? imageFile,
  });

  Future<Either<Failure, bool>> removeTransaction({
    required TransactionLocalModel transaction,
  });

  Future<void> clearAllData();
}
