import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/core_external.dart';

@LazySingleton()
class DioService {
  final Dio _cachedDio;
  final Dio _noCacheDio;

  DioService(
    @Named(dioWithCache) this._cachedDio,
    @Named(dioNoCache) this._noCacheDio,
  );

  Future<ApiResult<T>> _request<T>(Future<Response<T>> Function() call) async {
    try {
      final response = await call();
      return ApiResult.success(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('❌ [Dio Error]: ${e.type} -> ${e.message}');
        debugPrint('📩 [Server Response]: ${e.response?.data}');
      }

      return ApiResult.failure(e);
    } catch (e) {
      if (kDebugMode) debugPrint('❌ [Unexpected Error]: $e');
      return ApiResult.failure(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }

  /// GET
  Future<ApiResult<T>> getWithCache<T>(
    String endpoint, {
    Object? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _cachedDio.get<T>(
        endpoint,
        data: body,
        queryParameters: queryParameters,
      ),
    );
  }

  Future<ApiResult<T>> getNoCache<T>(
    String endpoint, {
    Object? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _noCacheDio.get<T>(
        endpoint,
        data: body,
        queryParameters: queryParameters,
      ),
    );
  }

  /// POST
  Future<ApiResult<T>> post<T>(
    String endpoint,
    Object? body, {
    Map<String, dynamic>? headers,
  }) {
    return _request(() => _cachedDio.post<T>(endpoint, data: body));
  }

  Future<ApiResult<T>> postNoAuthorize<T>(
    String endpoint,
    Object? body, {
    Map<String, dynamic>? headers,
  }) {
    return _request(() => _noCacheDio.post<T>(endpoint, data: body));
  }

  /// PATCH
  Future<ApiResult<T>> patch<T>(
    String endpoint,
    Object? body, {
    Map<String, dynamic>? headers,
  }) {
    return _request(() => _cachedDio.patch<T>(endpoint, data: body));
  }

  /// DELETE
  Future<ApiResult<T>> delete<T>(
    String endpoint, {
    Object? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) {
    return _request(
      () => _cachedDio.delete<T>(endpoint, data: body, queryParameters: params),
    );
  }

  /// Download
  Future<bool> downLoadFile(String urlPath, String savePath) async {
    try {
      final response = await _noCacheDio.download(
        urlPath,
        savePath,
        onReceiveProgress: (received, total) {
          if (kDebugMode && total != -1) {
            debugPrint(
              "📥 Download: ${(received / total * 100).toStringAsFixed(0)}%",
            );
          }
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
