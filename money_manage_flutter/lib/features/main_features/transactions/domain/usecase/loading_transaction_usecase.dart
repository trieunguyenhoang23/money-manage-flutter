import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../repositories/transaction_repository.dart';

@LazySingleton()
class LoadingTransactionUseCase {
  final TransactionRepository _repository;

  LoadingTransactionUseCase(this._repository);

  Future<List<TransactionLocalModel>> execute(
    int page,
    int month,
    year, {
    TransactionType? type,
  }) async {
    return await _repository.loadTransByMonth(page, month, year, type: type);
  }
}
