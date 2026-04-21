import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
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

    /// Attach the current Socket ID to exclude this device from receiving its own sync notification
    final sId = await _secureStorage.read(key: 'last_socket_id');
    if (sId != null) {
      options.headers['x-socket-id'] = sId;
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Prevent Infinite Loops: If the refresh call ITSELF failed with 401, stop.
      if (err.requestOptions.path.contains(UserAuthAPI.post_refresh_token)) {
        await getIt<UserLocalDatasource>().clearSession();
        return handler.next(err);
      }

      final refreshToken = await _secureStorage.read(key: refreshTokenKey);

      if (refreshToken != null) {
        try {
          // Use validateStatus so 401 doesn't throw an exception here
          final response = await _innerDio.post(
            UserAuthAPI.post_refresh_token,
            data: {'refreshToken': refreshToken},
            options: Options(validateStatus: (status) => status! < 500),
          );

          // Debug: See what the server actually says
          if (kDebugMode) {
            debugPrint('Refresh Response: ${response.data}');
          }

          if (response.statusCode == 200) {
            // Match keys exactly with your logs
            final newToken =
                response.data['accessToken']; // Matches your log JSON
            final newRefreshToken = response.data['refreshToken'];

            if (newToken != null) {
              // Save new credentials
              await _secureStorage.write(key: tokenKey, value: newToken);
              if (newRefreshToken != null) {
                await _secureStorage.write(
                  key: refreshTokenKey,
                  value: newRefreshToken,
                );
              }

              // Retry the original request with the new token
              final requestOptions = err.requestOptions;

              // Check if data is FormData and clone it if necessary
              dynamic data = requestOptions.data;
              if (data is FormData) {
                data = data.clone(); // This creates a fresh copy for the retry
              }

              final cloneReq = await _innerDio.request(
                requestOptions.path,
                data: data, // Use the (potentially cloned) data
                queryParameters: requestOptions.queryParameters,
                options: Options(
                  method: requestOptions.method,
                  headers: {
                    ...requestOptions.headers,
                    'Authorization': 'Bearer $newToken',
                  },
                  contentType: requestOptions.contentType,
                ),
              );

              return handler.resolve(cloneReq);
            }
          } else {
            // If status is 401/403, the refresh token is dead
            debugPrint('Refresh token expired or invalid server-side');
            await getIt<UserLocalDatasource>().clearSession();
          }
        } catch (e) {
          debugPrint('Interception Logic Error: $e');
          await getIt<UserLocalDatasource>().clearSession();
        }
      }
    }
    return handler.next(err);
  }
}
