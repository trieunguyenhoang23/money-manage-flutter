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
    Map<String, dynamic> updatedJson,
    CategoryLocalModel oldItem,
  ) async {
    // Validation Check
    if (updatedJson['name'] != null && updatedJson['name'].trim().length < 3) {
      return Left(ValidationFailure(ValidationCode.nameTooShort));
    }

    if (updatedJson['description'] != null &&
        updatedJson['description'].trim().isEmpty) {
      return Left(ValidationFailure(ValidationCode.descriptionEmpty));
    }

    bool hasChanged = oldItem.merge(
      newName: updatedJson['name'],
      newDescription: updatedJson['description'],
      newType: updatedJson['type'] != null
          ? TransactionType.fromDynamic(updatedJson['type'])
          : null,
    );

    return await repository.editCategory(updatedJson, oldItem, hasChanged);
  }
}
