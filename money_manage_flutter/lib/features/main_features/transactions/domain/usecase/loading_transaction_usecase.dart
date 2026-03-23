import 'package:injectable/injectable.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../repositories/transaction_repository.dart';

@LazySingleton()
class LoadingTransactionUseCase {
  final TransactionRepository _repository;

  LoadingTransactionUseCase(this._repository);

  Future<List<TransactionLocalModel>> execute(int page) async {
    return await _repository.loadTransByPage(page);
  }
}
