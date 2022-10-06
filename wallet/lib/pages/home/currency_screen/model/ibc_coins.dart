import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pylons_wallet/utils/constants.dart' as constants;
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

enum IBCCoins {
  urun,
  ujunox,
  none,
  ujuno,
  upylon,
  ustripeusd,
  eeur,
  uatom,
  weth_wei
}

extension IBCCoinsPar on String {
  IBCCoins toIBCCoinsEnum() {
    if (this == kEthereumSymbol) {
      return IBCCoins.weth_wei;
    }

    return IBCCoins.values.firstWhere((e) {
      return e.toString().toLowerCase() == 'IBCCoins.$this'.toLowerCase();
    }, orElse: () => IBCCoins.none); //return null if not found
  }
}

extension IBCCoinsDePar on IBCCoins {
  Widget getAssets() {
    switch (this) {
      case IBCCoins.urun:
        return SizedBox(
            width: 30.w,
            height: 30.w,
            child: SvgPicture.asset(SVGUtil.WALLET_AGORIC));
      case IBCCoins.ujunox:
        return SizedBox(
            width: 30.w,
            height: 30.w,
            child: SvgPicture.asset(SVGUtil.WALLET_JUNO));
      case IBCCoins.none:
        return SizedBox(
            width: 30.w,
            height: 30.w,
            child: SvgPicture.asset(SVGUtil.WALLET_AGORIC));
      case IBCCoins.ujuno:
        return SizedBox(
            width: 30.w,
            height: 30.w,
            child: SvgPicture.asset(SVGUtil.WALLET_JUNO));
      case IBCCoins.upylon:
        return SizedBox(
            width: 30.w,
            height: 30.w,
            child: Image.asset(
              ImageUtil.PYLONS_CURRENCY,
            ));

      case IBCCoins.ustripeusd:
        return SizedBox(
            width: 28.w,
            height: 30.w,
            child: Image.asset(ImageUtil.WALLET_USD));
      case IBCCoins.eeur:
        return SizedBox(
            width: 30.w,
            height: 30.w,
            child: SvgPicture.asset(SVGUtil.WALLET_EEUR));
      case IBCCoins.uatom:
        return SizedBox(
            width: 30.w,
            height: 30.w,
            child: SvgPicture.asset(SVGUtil.WALLET_ATOM));
      case IBCCoins.weth_wei:
        return SizedBox(
            width: 30.w,
            height: 30.w,
            child: SvgPicture.asset(SVGUtil.WALLET_ETH));
    }
  }

  String getName() {
    switch (this) {
      case IBCCoins.urun:
        return constants.kAgoric;
      case IBCCoins.ujunox:
        return constants.kJuno;
      case IBCCoins.none:
        return constants.kJuno;
      case IBCCoins.ujuno:
        return constants.kJuno;
      case IBCCoins.upylon:
        return constants.kPylons;
      case IBCCoins.ustripeusd:
        return constants.kDollar;
      case IBCCoins.eeur:
        return constants.kEmoney;
      case IBCCoins.uatom:
        return constants.kAtom;
      case IBCCoins.weth_wei:
        return constants.kEthereum;
    }
  }

  String getAbbrev() {
    switch (this) {
      case IBCCoins.urun:
        return constants.kAgoricAbr;
      case IBCCoins.ujunox:
        return constants.kJuno;
      case IBCCoins.none:
        return constants.kJuno;
      case IBCCoins.ujuno:
        return constants.kJuno;
      case IBCCoins.upylon:
        return constants.kPYLN_ABBREVATION;
      case IBCCoins.ustripeusd:
        return constants.kStripeUSD_ABR;
      case IBCCoins.eeur:
        return constants.kEmoneyAbb;
      case IBCCoins.uatom:
        return constants.kAtomAbr;
      case IBCCoins.weth_wei:
        return constants.kEthereumAbr;
    }
  }

  Color getColor() {
    switch (this) {
      case IBCCoins.urun:
        return AppColors.kAgoricColor;
      case IBCCoins.ujunox:
        return AppColors.kForwardIconColor;
      case IBCCoins.none:
        return Colors.blueGrey;
      case IBCCoins.ujuno:
        return AppColors.kForwardIconColor;
      case IBCCoins.upylon:
        return constants.AppColors.kAtomColor;
      case IBCCoins.ustripeusd:
        return AppColors.kUSDColor;
      case IBCCoins.eeur:
        return constants.AppColors.kEmoneyColor;
      case IBCCoins.uatom:
        return constants.AppColors.kAtomColor;
      case IBCCoins.weth_wei:
        return constants.AppColors.kEthereumColor;
    }
  }

  String getCoinWithProperDenomination(String amount) {
    switch (this) {
      case IBCCoins.urun:
      case IBCCoins.ujunox:
      case IBCCoins.none:
      case IBCCoins.eeur:
      case IBCCoins.ujuno:
      case IBCCoins.uatom:
      case IBCCoins.ustripeusd:
        return (double.parse(amount) / kBigIntBase).toStringAsFixed(2);
      case IBCCoins.upylon:
        return (double.parse(amount) / kBigIntBase).toStringAsFixed(0);
      case IBCCoins.weth_wei:
        return (double.parse(amount) / kEthIntBase).toStringAsFixed(2);
    }
  }

  String getCoinWithDenominationAndSymbol(String amount,
      {bool showDecimal = false}) {
    switch (this) {
      case IBCCoins.urun:
      case IBCCoins.ujunox:
      case IBCCoins.none:
      case IBCCoins.eeur:
      case IBCCoins.ujuno:

      case IBCCoins.uatom:
        return "${(double.parse(amount) / kBigIntBase).toStringAsFixed(kCurrencyDecimalLength)} ${getAbbrev()}";
      case IBCCoins.upylon:
        return "${(double.parse(amount) / kBigIntBase).toStringAsFixed(showDecimal ? kCurrencyDecimalLength : 0)} ${getAbbrev()}";
      case IBCCoins.ustripeusd:
        return "\$${(double.parse(amount) / kBigIntBase).toStringAsFixed(kCurrencyDecimalLength)}";
      case IBCCoins.weth_wei:
        return "${(double.parse(amount) / kEthIntBase).toStringAsFixed(kCurrencyDecimalLength)} ${getAbbrev()}";
    }
  }
}
