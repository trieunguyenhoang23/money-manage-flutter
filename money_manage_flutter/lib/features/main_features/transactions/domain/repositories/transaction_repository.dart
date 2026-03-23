import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import '../../../../../core/error/failure.dart';
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
    FilePicked? image,
  });
}
