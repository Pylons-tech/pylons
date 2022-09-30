import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/foundation.dart';

String _generateMnemonic(int strength) => bip39.generateMnemonic(strength: strength);

Future<String> generateMnemonic({int strength = 256}) => compute(_generateMnemonic, strength);

extension MnemonicWords on String {
  List<String> splitToWords() => split(RegExp(r'\s+')) //
      .where((element) => element.isNotEmpty)
      .toList();
}

/// Checks validity of [mnemonic] string and returns detailed error, if any.
/// Returns null if no error detected
MnemonicValidationError? validateMnemonic(String mnemonic) {
  if (mnemonic.isEmpty) {
    return MnemonicValidationError.MnemonicEmpty;
  } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(mnemonic)) {
    return MnemonicValidationError.InvalidCharacter;
  } else if (![12, 24].contains(mnemonic.splitToWords().length)) {
    return MnemonicValidationError.WrongNumberOfWords;
  } else if (!bip39.validateMnemonic(mnemonic)) {
    return MnemonicValidationError.Unknown;
  }
  return null;
}
// ignore_for_file: constant_identifier_names
enum MnemonicValidationError {
  MnemonicEmpty,
  InvalidCharacter,
  WrongNumberOfWords,
  Unknown,
}
