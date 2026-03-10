import 'package:dio/dio.dart';

class StringUtils {
  static String handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timed out. Check your internet.";
      case DioExceptionType.badResponse:
        return "Server error: ${e.response?.statusCode}";
      default:
        return "Something went wrong. Please try again.";
    }
  }
}
