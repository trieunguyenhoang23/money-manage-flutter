import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/core/di/injection.dart';
import '../../export/core.dart';
import '../../features/main_features/profile/data/datasource/local/user_local_datasource.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  final _innerDio = Dio(BaseOptions(baseUrl: APIConstants.bareUrl));

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(key: tokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _secureStorage.read(key: refreshTokenKey);

      if (refreshToken != null) {
        try {
          // Use the internal refreshDio to avoid triggering this interceptor again
          final response = await _innerDio.post(
            UserAuthAPI.post_refresh_token,
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200) {
            final newToken = response.data[tokenKey];
            final newRefreshToken = response.data['refreshToken'];

            await _secureStorage.write(key: tokenKey, value: newToken);
            await _secureStorage.write(
              key: refreshTokenKey,
              value: newRefreshToken,
            );

            final requestOptions = err.requestOptions;
            requestOptions.headers['Authorization'] = 'Bearer $newToken';

            final cloneReq = await _innerDio.request(
              requestOptions.path,
              options: Options(
                method: requestOptions.method,
                headers: requestOptions.headers,
                contentType: requestOptions.contentType,
              ),
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
            );

            return handler.resolve(cloneReq);
          }
        } catch (e) {
          getIt<UserLocalDatasource>().clearSession();
        }
      }
    }
    return handler.next(err);
  }
}
