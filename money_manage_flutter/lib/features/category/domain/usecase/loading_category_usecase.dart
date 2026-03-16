import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import '../../data/model/local/category_local_model.dart';
import '../repositories/category_repository.dart';

@LazySingleton()
class LoadingCategoryUseCase {
  final CategoryRepository _repository;

  LoadingCategoryUseCase(this._repository);

  Future<List<CategoryLocalModel>> execute(
    int page, {
    TransactionType? type,
  }) async {
    if (type != null) {
      return await _repository.loadCategoryByType(page, type);
    }
    return await _repository.loadCategoryByPage(page);
  }
}
