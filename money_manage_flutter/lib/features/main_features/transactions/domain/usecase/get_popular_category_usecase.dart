import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import 'package:money_manage_flutter/export/core_external.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../repositories/transaction_repository.dart';

@LazySingleton()
class GetPopularCategoryUseCase {
  final TransactionRepository _repository;

  GetPopularCategoryUseCase(this._repository);

  Future<List<CategoryLocalModel>> execute(TransactionType type, int range) async {
    return await _repository.getCategoryThroughTrans(type,range);
  }
}
