import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../data/model/local/transaction_local_model.dart';

abstract class TransactionRepository {
  Future<List<TransactionLocalModel>> loadTransByPage(int page);

  Future<List<CategoryLocalModel>> getCategoryThroughTrans(
    TransactionType type,
    int range,
  );

  Future<Either<Failure, TransactionLocalModel>> addTransaction({
    required double amount,
    required String note,
    required CategoryLocalModel category,
    required DateTime transactionAt,
    FilePicked? imageFile,
  });

  Future<Either<Failure, TransactionLocalModel>> updateTransaction({
    required Map<String, dynamic> updateJsonRequestBody,
    required TransactionLocalModel oldItem,
    required CategoryLocalModel newCate,
    FilePicked? imageFile,
  });

  Future<Either<Failure, bool>> removeTransaction({
    required TransactionLocalModel transaction,
  });
}
