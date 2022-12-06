import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PercentageSignFormatter extends TextInputFormatter {
  PercentageSignFormatter({this.maxDigits = 2});

  int maxDigits;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0 && newValue.text.isEmpty) {
      return newValue;
    }
    if (newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }
    final double value = double.parse(newValue.text);
    final formatter = NumberFormat.percentPattern("en_US");
    final String newText = formatter.format(value / 100);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
