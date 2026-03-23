import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/core/error/failure.dart';
import 'package:money_manage_flutter/export/core_external.dart';
import '../../../../../infrastructure/file/models/file_picked.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../repositories/transaction_repository.dart';

@LazySingleton()
class CreateTransactionUseCase {
  final TransactionRepository _repository;

  CreateTransactionUseCase(this._repository);

  Future<Either<Failure, TransactionLocalModel>> execute({
    required double amount,
    required String note,
    required CategoryLocalModel category,
    required DateTime transactionAt,
     FilePicked? image,
  }) async {
    return await _repository.addTransaction(
      amount: amount,
      note: note,
      category: category,
      transactionAt: transactionAt,
      image: image,
    );
  }
}
