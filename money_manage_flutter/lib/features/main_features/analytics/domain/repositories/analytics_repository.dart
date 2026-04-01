import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, Tuple3<double, double, double>>> getFinancialData();
}
