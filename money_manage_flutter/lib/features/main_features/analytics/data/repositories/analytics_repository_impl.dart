import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../../sync/data/datasource/local/sync_local_storage.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasource/local/analytics_local_datasource.dart';
import '../datasource/remote/analytics_remote_datasource.dart';
import '../model/category_analytics_model.dart';

@LazySingleton(as: AnalyticsRepository)
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDatasource _analyticsRemoteDatasource;
  final AnalyticsLocalDatasource _analyticsLocalDatasource;
  final OnlineActionGuard _onlineActionGuard;
  final SyncLocalStorage _syncLocalStorage;

  AnalyticsRepositoryImpl(
    this._analyticsLocalDatasource,
    this._analyticsRemoteDatasource,
    this._onlineActionGuard,
    this._syncLocalStorage,
  );

  @override
  Future<Either<Failure, Tuple3<double, double, double>>>
  getFinancialData() async {
    double income = await _analyticsLocalDatasource.getIncome();
    double expense = await _analyticsLocalDatasource.getExpense();

    await _onlineActionGuard.run((currentUserId, isConnected) async {
      /// Only fetching data from server when transaction lazy loading hasn't finished
      bool isCatSynced = _syncLocalStorage.isFirstSyncCompleted(
        SyncSchema.category,
      );
      bool isTransSynced = _syncLocalStorage.isFirstSyncCompleted(
        SyncSchema.transaction,
      );

      if (!isCatSynced || !isTransSynced) {
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
    await _onlineActionGuard.run((currentUserId, isConnected) async {
      bool isCatSynced = _syncLocalStorage.isFirstSyncCompleted(
        SyncSchema.category,
      );
      bool isTransSynced = _syncLocalStorage.isFirstSyncCompleted(
        SyncSchema.transaction,
      );

      if (!isCatSynced || !isTransSynced) {
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
  Future<Either<Failure, Map<String, dynamic>>> getOverviewAnalytics(
    DateTime dateStart,
    DateTime dateEnd,
    String groupBy,
  ) async {
    Map<String, dynamic> overviewAnalytics = await _analyticsLocalDatasource
        .getCumulativeData(dateStart, dateEnd, groupBy);
    String? error;

    await _onlineActionGuard.run((currentUserId, isConnected) async {
      bool isTransSynced = _syncLocalStorage.isFirstSyncCompleted(
        SyncSchema.transaction,
      );

      /// Only fetch data from server if sync data hasn't done
      if (!isTransSynced) {
        final result = await _analyticsRemoteDatasource.getOverviewAnalytics(
          dateStart.formatServerStart,
          dateEnd.formatServerEnd,
          groupBy,
        );

        if (result.isFailure) {
          error = result.error?.message;
          return;
        }

        /// Assign the correct data from server
        overviewAnalytics = result.data;
      }
    });

    if (error != null) return Left(ServerFailure(error!));
    return Right(overviewAnalytics);
  }
}
