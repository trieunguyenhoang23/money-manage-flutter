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
    /// Standardization range time
    final startStandardization = dateStart.formatStartOfDay!;
    final endStandardization = dateEnd.formatEndOfDay!;

    final result =  await _analyticsRepository.getSpendingCateAnalytics(
      type.name.toUpperCase(),
      startStandardization,
      endStandardization,
    );

    return result.map((list) {
      final total = list.fold<double>(0, (sum, item) => sum + item.totalAmount);

      return list.map((item) => item.copyWith(
        percentage: total > 0 ? (item.totalAmount / total) * 100 : 0,
      )).toList();
    });
  }
}
