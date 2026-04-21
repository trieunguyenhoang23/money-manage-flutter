import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/core/constant/api_constants.dart';
import 'package:money_manage_flutter/core/network/api_result.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';

@LazySingleton()
class AnalyticsRemoteDatasource {
  final DioService _dioService;

  AnalyticsRemoteDatasource(this._dioService);

  Future<ApiResult> getFinancialData() async {
    return await _dioService.getNoCache(AnalyticsAPI.get_financial_data);
  }

  Future<ApiResult> getCategoryAnalytics(
    String type,
    String startDate,
    String endDate,
  ) async {
    return await _dioService.getNoCache(
      AnalyticsAPI.get_spending_categories,
      queryParameters: {
        'type': type,
        'startDate': startDate,
        'endDate': endDate,
      },
    );
  }

  Future<ApiResult> getOverviewAnalytics(
    String startDate,
    String endDate,
    String groupBy,
  ) async {
    return await _dioService.getNoCache(
      AnalyticsAPI.get_overview,
      queryParameters: {
        'startDate': startDate,
        'endDate': endDate,
        'groupBy': groupBy,
      },
    );
  }
}
