import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/core/error/failure.dart';

import '../../../../../export/core_external.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../repositories/transaction_repository.dart';

@LazySingleton()
class RemoveTransactionUseCase {
  final TransactionRepository _repository;

  RemoveTransactionUseCase(this._repository);

  Future<Either<Failure,bool>> execute(TransactionLocalModel transaction) async {
    return await _repository.removeTransaction(transaction: transaction);
  }
}
