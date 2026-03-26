import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../data/model/local/category_local_model.dart';
import '../repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

@LazySingleton()
class EditCategoryUseCase {
  final CategoryRepository repository;

  EditCategoryUseCase(this.repository);

  Future<Either<Failure, CategoryLocalModel>> execute(
    Map<String,dynamic> updatedJson,
    CategoryLocalModel oldItem,
  ) async {
    // Validation Check
    if (updatedJson['name'].trim().length < 3) {
      return Left(ValidationFailure(ValidationCode.nameTooShort));
    }

    if (updatedJson['description'].trim().isEmpty) {
      return Left(ValidationFailure(ValidationCode.descriptionEmpty));
    }

    return await repository.editCategory(updatedJson,oldItem);
  }
}
