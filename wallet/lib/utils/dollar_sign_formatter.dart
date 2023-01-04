import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DollarSignFormatter extends TextInputFormatter {
  DollarSignFormatter({required this.maxDigits});
  int maxDigits;


  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    if (newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }

    final value = double.parse(newValue.text);
    final formatter = NumberFormat( "\$", "en_US");
    final newText = formatter.format( value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
