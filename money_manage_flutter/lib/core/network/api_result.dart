import 'package:dio/dio.dart';

class ApiResult<T> {
  final T? data;
  final DioException? error;

  ApiResult.success(this.data) : error = null;

  ApiResult.failure(this.error) : data = null;

  bool get isSuccess => error == null;

  bool get isFailure => error != null;
}
