import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

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

  static String formatPrice(String price, String currencyCode) {
    final format = NumberFormat.simpleCurrency(
      name: currencyCode,
      decimalDigits: 0,
    );
    final parsedPrice = double.parse(price);
    return format.format(parsedPrice);
  }

  static String formatNumber(String price) {
    final parsedPrice = double.parse(price);

    final format = NumberFormat.decimalPattern('vi_VN');
    return format.format(parsedPrice.toInt());
  }

  static String formatYAxis(double val) {
    if (val >= 1000000) {
      return '${(val / 1000000).toStringAsFixed(1)}M';
    } else if (val >= 1000) {
      return '${(val / 1000).toStringAsFixed(1)}k';
    }
    return val.toStringAsFixed(1);
  }
}
