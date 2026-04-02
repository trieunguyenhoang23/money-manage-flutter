import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../data/model/overview_analytics_model.dart';
import '../repositories/analytics_repository.dart';

@LazySingleton()
class GetOverviewUseCase {
  final AnalyticsRepository _analyticsRepository;

  GetOverviewUseCase(this._analyticsRepository);

  Future<Either<Failure, OverviewAnalytics>> execute(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _analyticsRepository.getOverviewAnalytics(startDate, endDate);
  }
}
