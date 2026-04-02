import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../../../export/core_external.dart';
import '../../data/model/category_analytics_model.dart';
import '../repositories/analytics_repository.dart';

@LazySingleton()
class GetCategoriesAnalyticsUseCase {
  final AnalyticsRepository _analyticsRepository;

  GetCategoriesAnalyticsUseCase(this._analyticsRepository);

  Future<Either<Failure, List<CategoryAnalytics>>> execute(
    TransactionType type,
    DateTime dateStart,
    DateTime dateEnd,
  ) async {
    return await _analyticsRepository.getSpendingCateAnalytics(
      type.name.toUpperCase(),
      dateStart,
      dateEnd,
    );
  }
}
