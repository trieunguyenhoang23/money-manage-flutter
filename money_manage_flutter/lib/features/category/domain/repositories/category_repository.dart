import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/local/category_local_model.dart';

abstract class CategoryRepository {
  Future<Either<Failure, CategoryLocalModel>> createCategory(
    CategoryLocalModel categoryLocalModel,
  );

  Future<Either<Failure, CategoryLocalModel>> editCategory(
    Map<String, dynamic> updatedJson,
    CategoryLocalModel oldItem,
    bool hasChanged,
  );

  Future<List<CategoryLocalModel>> loadCategoryByPage(
    int page,
    int limitCount,
    bool isSynced,
  );

  Future<void> clearAllData();
}
