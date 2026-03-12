import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';

import '../../../../../core/constant/api_constants.dart';
import '../../../../../core/network/api_result.dart';

@LazySingleton()
class SyncRemoteDatasource {
  final DioService _dioService;

  SyncRemoteDatasource(this._dioService);

  Future<ApiResult> syncUserData(
    Map<String, dynamic> arrayJsonBody,
  ) async {
    final response = await _dioService.post(
      SyncAPI.post_sync_user_data,
      arrayJsonBody,
    );

    return response;
  }
}
