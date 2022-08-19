import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AmountFormatter extends TextInputFormatter {
  AmountFormatter({required this.maxDigits, this.isDecimal = false});

  int maxDigits;
  bool isDecimal;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    maxDigits = 20;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    if (newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }
    double value = double.parse(newValue.text);
    final formatter = NumberFormat(isDecimal ? "#,##0.00" : "#,###", "en_US");
    String newText = formatter.format(isDecimal ? value / 100 : value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
