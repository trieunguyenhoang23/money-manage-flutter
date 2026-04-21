import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/core/constant/api_constants.dart';
import 'package:money_manage_flutter/core/network/api_result.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';

@LazySingleton()
class UserRemoteDatasource {
  final DioService _dioService;

  UserRemoteDatasource(this._dioService);

  /// GET
  Future<ApiResult> getUserCurrency() async {
    return await _dioService.getWithCache(UserBaseAPI.get_user_currency);
  }

  /// POST
  Future<dynamic> verifyAuthenticate({
    required Map<String, dynamic> jsonBody,
  }) async {
    final response = await _dioService.postNoAuthorize(
      UserAuthAPI.post_verify_auth,
      jsonBody,
    );

    if (response.isFailure) {
      return response.error?.message ?? '';
    }

    return response.data;
  }

  Future<ApiResult> updateUserProperties(
    Map<String, dynamic> jsonBodyRequest,
  ) async {
    return await _dioService.patch(UserBaseAPI.patch_user, jsonBodyRequest);
  }

  Future<ApiResult> logout(String refreshToken) async {
    return await _dioService.post(
      UserAuthAPI.post_log_out,
      {},
      headers: {'x-refresh-token': refreshToken},
    );
  }
}
