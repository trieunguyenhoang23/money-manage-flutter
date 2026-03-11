import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/core/constant/api_constants.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';

@LazySingleton()
class UserRemoteDatasource {
  DioService _dioService;

  UserRemoteDatasource(this._dioService);

  Future<dynamic> verifyAuthenticate({
    required Map<String, dynamic> jsonBody,
  }) async {
    final response = await _dioService.postNoAuthorize(
      UserAuth.verifyAuth,
      jsonBody,
    );

    if (response.isFailure) {
      return response.error?.message ?? '';
    }

    return response.data;
  }
}
