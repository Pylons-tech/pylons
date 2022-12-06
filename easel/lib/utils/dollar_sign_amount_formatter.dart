import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DollarSignAmountFormatter extends TextInputFormatter {
  DollarSignAmountFormatter({this.maxDigits = 20});

  int maxDigits;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    if (newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }

    final value = double.parse(newValue.text);
    final formatter = NumberFormat("\$#0.00", "en_US");
    final newText = formatter.format(value/100);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
