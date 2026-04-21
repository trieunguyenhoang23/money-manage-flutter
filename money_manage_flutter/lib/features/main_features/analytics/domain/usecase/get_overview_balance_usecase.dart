import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/core/error/failure.dart';
import '../repositories/analytics_repository.dart';

@LazySingleton()
class GetOverviewBalanceUseCase {
  final AnalyticsRepository _analyticsRepository;

  GetOverviewBalanceUseCase(this._analyticsRepository);

  Future<Either<Failure, Tuple3<double, double, double>>> execute() async {
    return await _analyticsRepository.getFinancialData();
  }
}
