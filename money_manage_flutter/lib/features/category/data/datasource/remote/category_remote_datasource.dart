import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/core/constant/api_constants.dart';
import 'package:money_manage_flutter/core/network/api_result.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';

@LazySingleton()
class CategoryRemoteDatasource {
  final DioService _dioService;

  CategoryRemoteDatasource(this._dioService);

  Future<ApiResult> loadCateByPage(int page, int limit_count) async {
    final response = await _dioService.getWithCache(
      '${CategoryAPI.get_load_by_page}?'
      'page=$page&'
      'limit_count=$limit_count',
    );

    return response;
  }
}
