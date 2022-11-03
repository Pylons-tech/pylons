import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/utils/constants.dart';

import '../utils/amount_formatter.dart';
import '../utils/image_util.dart';

class Denom {
  final String name;
  final String symbol;
  final String icon;

  Denom({required this.name, required this.symbol, required this.icon});

  factory Denom.initial() {
    return Denom(icon: '', name: '', symbol: '');
  }

  static List<Denom> get availableDenoms => [
        Denom(name: kStripeUSD_ABR, symbol: kUSDDenom, icon: ImageUtil.WALLET_USD),
        Denom(name: kDenomPylon, symbol: kUpylon, icon: ImageUtil.PYLON_1H_CURRENCY_WHITE),
      ];

  TextInputFormatter getFormatter() {
    if (symbol == kUpylon) {
      return AmountFormatter(maxDigits: kMaxPriceLength);
    }
    return AmountFormatter(maxDigits: kMaxPriceLength, isDecimal: true);
  }

  @override
  String toString() {
    return 'Denom{name: $name, symbol: $symbol, icon: $icon}';
  }

  Widget getIconWidget() {
    switch (symbol) {
      case kUSDDenom:
      case kUpylon:
        return Image.asset(
          icon,
          height: 20.h,
          fit: BoxFit.contain,
          width: 20.w,
        );
      default:
        return Image.asset(icon);
    }
  }

}
