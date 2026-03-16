import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/enum/transaction_type.dart';
import '../../data/model/local/category_local_model.dart';

abstract class CategoryRepository {
  Future<Either<Failure, CategoryLocalModel>> createCategory(
    String name,
    String desc,
    TransactionType type,
  );

  Future<Either<Failure, CategoryLocalModel>> editCategory(
    String name,
    String desc,
    TransactionType type,
    CategoryLocalModel oldItem,
  );

  Future<List<CategoryLocalModel>> loadCategoryByPage(int page);

  Future<List<CategoryLocalModel>> loadCategoryByType(int page, TransactionType type);


  Future<void> clearAllData();
}
