import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../profile/data/datasource/local/user_local_datasource.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasource/local/analytics_local_datasource.dart';
import '../datasource/remote/analytics_remote_datasource.dart';
import '../model/category_analytics_model.dart';
import '../model/overview_analytics_model.dart';

@LazySingleton(as: AnalyticsRepository)
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDatasource _analyticsRemoteDatasource;
  final AnalyticsLocalDatasource _analyticsLocalDatasource;
  final UserLocalDatasource _userLocalDatasource;
  final SyncManager _syncManager;
  final SyncLazyLoading _syncLazyLoading;

  AnalyticsRepositoryImpl(
    this._analyticsLocalDatasource,
    this._analyticsRemoteDatasource,
    this._syncManager,
    this._syncLazyLoading,
    this._userLocalDatasource,
  );

  @override
  Future<Either<Failure, Tuple3<double, double, double>>>
  getFinancialData() async {
    double income = await _analyticsLocalDatasource.getIncome();
    double expense = await _analyticsLocalDatasource.getExpense();

    await _syncManager.runIfMeetStandard((currentUserId, isConnected) async {
      /// Only fetching data from server when transaction lazy loading hasn't finished
      if (!_syncLazyLoading.hasReachedEnd(SyncSchema.category) &&
          !_syncLazyLoading.hasReachedEnd(SyncSchema.transaction)) {
        await _analyticsRemoteDatasource.getFinancialData().then((result) {
          if (result.isFailure) return Left(result.error?.message);

          income = double.tryParse(result.data['income'].toString()) ?? 0;
          expense = double.tryParse(result.data['expense'].toString()) ?? 0;
        });
      }
    });

    double currentBalance = income - expense;
    return Right(Tuple3(currentBalance, income, expense));
  }

  @override
  Future<Either<Failure, List<CategoryAnalytics>>> getSpendingCateAnalytics(
    String type,
    DateTime dateStart,
    DateTime dateEnd,
  ) async {
    List<CategoryAnalytics> categoriesAnalytics =
        await _analyticsLocalDatasource.getCategoryAnalytics(
          TransactionType.fromDynamic(type),
          dateStart,
          dateEnd,
        );

    String? error;
    await _syncManager.runIfMeetStandard((currentUserId, isConnected) async {
      if (!_syncLazyLoading.hasReachedEnd(SyncSchema.category) &&
          !_syncLazyLoading.hasReachedEnd(SyncSchema.transaction)) {
        final result = await _analyticsRemoteDatasource.getCategoryAnalytics(
          type,
          dateStart.formatServerStart,
          dateEnd.formatServerEnd,
        );

        if (result.isFailure) {
          error = result.error?.message;
          return;
        }

        categoriesAnalytics = await parseListJsonIsolate(
          CategoryAnalytics.fromJson,
          result.data,
        );
      }
    });

    if (error != null) return Left(ServerFailure(error!));
    return Right(categoriesAnalytics);
  }

  @override
  Future<Either<Failure, OverviewAnalytics>> getOverviewAnalytics(
    DateTime dateStart,
    DateTime dateEnd,
  ) async {
    OverviewAnalytics overviewAnalytics = await _analyticsLocalDatasource
        .getOverview(dateStart, dateEnd);
    String? error;

    await _syncManager.runIfMeetStandard((currentUserId, isConnected) async {
      if (!_syncLazyLoading.hasReachedEnd(SyncSchema.transaction)) {
        final result = await _analyticsRemoteDatasource.getOverviewAnalytics(
          dateStart.formatServerStart,
          dateEnd.formatServerEnd,
        );

        if (result.isFailure) {
          error = result.error?.message;
          return;
        }

        overviewAnalytics = await parseItemJsonIsolate(
          OverviewAnalytics.fromJson,
          result.data,
        );
      }
    });

    if (error != null) return Left(ServerFailure(error!));
    return Right(overviewAnalytics);
  }
}
