import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../data/model/category_analytics_model.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, Tuple3<double, double, double>>> getFinancialData();

  Future<Either<Failure, List<CategoryAnalytics>>> getSpendingCateAnalytics(
    String type,
  );
}
