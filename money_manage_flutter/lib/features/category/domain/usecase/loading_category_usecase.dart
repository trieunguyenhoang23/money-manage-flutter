import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../data/model/local/category_local_model.dart';
import '../repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

@LazySingleton()
class LoadingCategoryUseCase {
  final CategoryRepository _repository;

  LoadingCategoryUseCase(this._repository);

  Future<List<CategoryLocalModel>> execute(int page) async {
    return await _repository.loadCategoryByPage(page);
  }
}
