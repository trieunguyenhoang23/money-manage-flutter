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

  String formatDate(BuildContext context) {
    if (this == null) return '';
    final String locale = Localizations.localeOf(context).toString();
    return DateFormat.yMd(locale).format(this!);
  }

  String formatDateLong(BuildContext context) {
    if (this == null) return '';
    final String locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMMd(locale).format(this!);
  }

  String get formatServerStart {
    if (this == null) return '';
    return DateTime(
      this!.year,
      this!.month,
      this!.day,
      0,
      0,
      0,
    ).toUtc().toIso8601String();
  }

  String get formatServerEnd {
    if (this == null) return '';
    return DateTime(
      this!.year,
      this!.month,
      this!.day,
      23,
      59,
      59,
      999,
    ).toUtc().toIso8601String();
  }
}

extension DateTimeRangeLocaleX on DateTimeRange? {
  /// Formats the range based on locale.
  /// VN: 10/03/2026 - 15/03/2026
  /// US: 03/10/2026 - 03/15/2026
  String formatDateRange(BuildContext context) {
    if (this == null) return '';

    final String locale = Localizations.localeOf(context).toString();
    // yMd automatically handles the order of day/month/year based on locale
    final DateFormat formatter = DateFormat.yMd(locale);

    return "${formatter.format(this!.start)} - ${formatter.format(this!.end)}";
  }

  /// Formats with month names (Long version)
  /// VN: 10 thg 3, 2026 - 15 thg 3, 2026
  /// US: Mar 10, 2026 - Mar 15, 2026
  String formatDateRangeLong(BuildContext context) {
    if (this == null) return '';

    final String locale = Localizations.localeOf(context).toString();
    final DateFormat formatter = DateFormat.yMMMd(locale);

    return "${formatter.format(this!.start)} - ${formatter.format(this!.end)}";
  }
}
