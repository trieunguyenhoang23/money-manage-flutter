import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final int maxLength;

  CurrencyInputFormatter({required this.maxLength});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > maxLength) {
      return oldValue;
    }

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Format with dots (5000000 => 5.000.000)
    final formatter = NumberFormat.decimalPattern('vi_VN');
    String formattedText = formatter.format(int.parse(newText));

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
