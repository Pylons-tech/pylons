import 'package:decimal/decimal.dart';
import 'package:pylons_wallet/utils/constants.dart' as constants;

extension TrimZeroString on String {
  String trimZero() {
    return num.parse(this).toString();
  }
}

extension AmountValue on String {
  String UvalToVal() {
    final amount = this == "" ? "0" : this;
    return (num.parse(amount) / constants.kBigIntBase).toString();
  }

  String UvalToValInt() {
    final amount = this == "" ? "0" : this;
    return (num.parse(amount) ~/ constants.kBigIntBase).toString();
  }

  String ValToUval() {
    return (Decimal.parse(this) * Decimal.fromInt(constants.kBigIntBase)).toBigInt().toString();
  }
}

extension DenomValue on String {
  String UdenomToDenom() {
    if (this == constants.kPylonDenom) {
      return constants.kPylonCoinName;
    } else if (this == constants.kUSDDenom) {
      return constants.kUSDCoinName;
    } else if (startsWith("u")) {
      return substring(1);
    }
    return this;
  }

  String DenomToUdenom() {
    if (toLowerCase() == constants.kPylonCoinName) {
      return constants.kPylonDenom;
    } else if (toLowerCase() == constants.kUSDCoinName) {
      return constants.kUSDDenom;
    } else if (!toLowerCase().startsWith("u")) {
      return "u${toLowerCase()}";
    }
    return this;
  }
}
