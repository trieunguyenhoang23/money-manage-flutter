import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../../core/enum/transaction_type.dart';
import '../../data/model/local/category_local_model.dart';
import '../repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

@LazySingleton()
class CreateCategoryUseCase {
  final CategoryRepository repository;

  CreateCategoryUseCase(this.repository);

  Future<Either<Failure, CategoryLocalModel>> execute(
    String name,
    String desc,
    TransactionType type,
  ) async {
    // Validation Check
    if (name.trim().length < 3) {
      return Left(ValidationFailure(ValidationCode.nameTooShort));
    }

    if (desc.trim().isEmpty) {
      return Left(ValidationFailure(ValidationCode.descriptionEmpty));
    }

    // 2. If valid, proceed to repository
    return await repository.createCategory(name, desc, type);
  }
}
