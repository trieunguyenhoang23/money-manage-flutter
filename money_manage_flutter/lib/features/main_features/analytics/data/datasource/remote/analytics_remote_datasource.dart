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
}
