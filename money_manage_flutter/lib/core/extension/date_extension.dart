import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeLocaleX on DateTime? {
  /// Định dạng Ngày & Giờ tự động theo quốc gia
  /// Ví dụ VN: 10/03/2026 14:30
  /// Ví dụ US: 03/10/2026 2:30 PM
  String formatFull(BuildContext context) {
    if (this == null) return '';
    final String locale = Localizations.localeOf(context).toString();
    return DateFormat.yMd(locale).add_jm().format(this!);
  }
}