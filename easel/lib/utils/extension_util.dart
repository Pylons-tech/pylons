import 'dart:math';

import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:pylons_sdk/pylons_sdk.dart';

extension ScaffoldHelper on BuildContext? {
  void show({required String message}) {
    if (this == null) {
      return;
    }

    ScaffoldMessenger.maybeOf(this!)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        duration: const Duration(seconds: 2),
      ));
  }
}

extension ScaffoldStateHelper on ScaffoldMessengerState {
  void show({required String message}) {
    this
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        duration: const Duration(seconds: 2),
      ));
  }
}

extension ScaffoldMessengerKeyHelper on GlobalKey<NavigatorState> {
  ScaffoldMessengerState? getState() {
    if (navigatorKey.currentState == null) {
      return null;
    }

    if (navigatorKey.currentState!.overlay == null) {
      return null;
    }

    return ScaffoldMessenger.maybeOf(navigatorKey.currentState!.overlay!.context);
  }
}

extension NavigatorKey on GlobalKey {
  void showMsg({required String message}) {
    ScaffoldMessenger.maybeOf(currentState!.context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        duration: const Duration(seconds: 2),
      ));
  }
}

extension ValueConverter on String {
  double fromBigInt() {
    if (this == "") {
      return 0;
    }
    return BigInt.parse(this).toDouble() / kPrecision;
  }
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

extension AssetTypePar on String {
  AssetType toAssetTypeEnum() {
    var value = this;
    if (value == k3dText) {
      value = kThreeDText;
    }

    return AssetType.values.firstWhere((e) => e.toString() == 'AssetType.$value', orElse: () => AssetType.Image);
  }
}

extension FreeDropEnum on String {
  FreeDrop toFreeDropEnum() {
    return FreeDrop.values.firstWhere((e) => e.toString() == 'FreeDrop.$this', orElse: () => FreeDrop.unselected);
  }
}

extension RemoveSpacesFileName on String {
  String removeSpacesFileName() {
    final name = split('/').last;
    return replaceAll(name, name.replaceAll(" ", "_"));
  }
}

extension DurationConverter on int {
  String toSeconds() {
    final double seconds = this / kNumberOfSeconds;
    final String min = (seconds / kSixtySeconds).toString().split(".").first;
    final String sec = (seconds % kSixtySeconds).toString().split(".").first;

    return "$min:$sec";
  }
}

extension NFTValue on NFT {
  String getPriceFromRecipe(Recipe recipe) {
    if (recipe.coinInputs.isEmpty) {
      return "0";
    }
    if (recipe.coinInputs.first.coins.isEmpty) {
      return "0";
    }
    return recipe.coinInputs.first.coins.first.amount;
  }
}

extension MyStringSnackBar on String {
  void show({BuildContext? context}) {
    ScaffoldMessenger.of(context ?? navigatorKey.currentState!.overlay!.context).showSnackBar(
      SnackBar(
        content: Text(
          this,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

extension FileExtension on String {
  String getFileExtension() {
    return path.extension(this).replaceAll(".", "");
  }
}

extension FileSizeInGB on int {
  double getFileSizeInGB() {
    return this / (1024 * 1024 * 1024).toDouble();
  }
}

extension FileSizeString on int {
  String getFileSizeString({required int precision}) {
    final i = (log(this) / log(1024)).floor();
    return ((this / pow(1024, i)).toStringAsFixed(precision)) + suffixes[i];
  }
}

extension GenerateEaselLink on String {
  String generateEaselLinkToShare({required String cookbookId}) {
    return "$kWalletWebLink/?action=purchase_nft&recipe_id=$this&cookbook_id=$cookbookId";
  }
}

extension GenerateEaselLinkToOpenPylons on String {
  String generateEaselLinkForOpeningInPylonsApp({required String cookbookId}) {
    return Uri.https('pylons.page.link', "/", {
      "amv": "1",
      "apn": "tech.pylons.wallet",
      "ibi": "xyz.pylons.wallet",
      "imv": "1",
      "link": "https://wallet.pylons.tech/?action=purchase_nft&recipe_id=$this&cookbook_id=$cookbookId&nft_amount=1"
    }).toString();
  }
}

extension IsSvgExtension on String {
  bool isSvg() {
    String extension = "";
    extension = path.extension(this);
    return extension == ".svg";
  }
}

extension ChangeDomain on String {
  String changeDomain() {
    if (!contains(ipfsDomain)) {
      return this;
    }
    return replaceAll(ipfsDomain, proxyIpfsDomain);
  }
}

extension TrimString on String {
  String trimString(int minThreshold) {
    if (length > minThreshold) {
      return "${substring(0, 8)}...${substring(length - 4, length)}";
    }
    return this;
  }
}

extension GetCoinWithProperDenomination on String {
  String getCoinWithProperDenomination(String amount) {
    if (this == kUsdSymbol) {
      return (double.parse(amount) / kBigIntBase).toStringAsFixed(2);
    } else if (this == kPylonSymbol) {
      return (double.parse(amount) / kBigIntBase).toStringAsFixed(0);
    } else {
      return (double.parse(amount) / kEthIntBase).toStringAsFixed(2);
    }
  }

   String getEaselInputCoinWithDenomination(String amount) {
    if (this == kUsdSymbol) {
      return (double.parse(amount)).toStringAsFixed(2);
    } else if (this == kPylonSymbol) {
      return (double.parse(amount)).toStringAsFixed(0);
    } else {
      return (double.parse(amount)).toStringAsFixed(2);
    }
  }
}

extension GetAbbrev on String {
  String getAbbrev() {
    switch (this) {
      case kAgoricSymbol:
        return kAgoricAbr;
      case kPylonSymbol:
        return kPYLNAbbrevation;
      case kUsdSymbol:
        return kStripeUSDABR;
      case kEuroSymbol:
        return kEmoneyAbb;
      case kAtomSymbol:
        return kAtomAbr;
      case kEthereumSymbol:
        return kEthereumAbr;
      default:
        return kPYLNAbbrevation;
    }
  }
}
