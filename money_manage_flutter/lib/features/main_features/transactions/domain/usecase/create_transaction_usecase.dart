import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/core/error/failure.dart';
import 'package:money_manage_flutter/export/core_external.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../repositories/transaction_repository.dart';

@LazySingleton()
class CreateTransactionUseCase {
  final TransactionRepository _repository;

  CreateTransactionUseCase(this._repository);

  Future<Either<Failure, TransactionLocalModel>> execute() async {
    return Left(ServerFailure('e'));
  }
}
