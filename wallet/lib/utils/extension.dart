import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/model/transaction.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';

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
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp),
        ),
        duration: const Duration(seconds: 2),
      ));
  }
}

extension ConvertToUSD on String {
  String convertToUSD(TransactionHistory item) {
    switch (this) {
      case kPylonCoinName:
        return (double.parse(convertFromU(item)) * pyLonToUsdConstant).toInt().toString();
    }
    return '';
  }
}

extension ConvertFromU on String {
  String convertFromU(TransactionHistory item) {
    switch (this) {
      case kPylonCoinName:
        return (double.parse(item.amount.substring(0, item.amount.length - (length + 1))) / kBigIntBase).toString().truncateAfterDecimal(2);
    }
    return '';
  }
}

extension FailureTypeEnumExt on String {
  FailureTypeEnum toFailureTypeEnum() {
    return FailureTypeEnum.values.firstWhere((e) => e.toString() == this, orElse: () => FailureTypeEnum.Unknown);
  }
}

extension SplitNumAlpha on String {
  List<String> splitNumberAndAlpha() => <String>[...RegExp(r'\d+|\D+').allMatches(this).map((match) => match[0]!).map((string) => string)];
}

extension GetDynamicLink on String {
  String createDynamicLink({required String cookbookId, required String address}) {
    return "$kUnilinkUrl/?recipe_id=$this&cookbook_id=$cookbookId&address=$address";
  }

  String createTradeLink({required String address}) {
    return "$kUnilinkUrl/?trade_id=$this&address=$address";
  }

  String createPurchaseNFT({required String cookBookId, required String address}) {
    return "$kUnilinkUrl/?cookbook_id=$cookBookId&item_id=$this&address=$address";
  }
}

extension StringExtension on String {
  String truncateAfterDecimal(int maxLength) {
    if (!contains(".")) {
      return this;
    }

    if (length - indexOf(".") > maxLength) {
      return substring(0, indexOf(".") + maxLength);
    }

    return this;
  }
}

extension NftSize on NFT {
  String getAssetSize() {
    switch (assetType) {
      case AssetType.Audio:
        return '$duration min';

      case AssetType.Image:
        return '$width x $height px JPG';

      case AssetType.Video:
        return '$duration min';

      case AssetType.ThreeD:
        return fileSize;

      default:
        return "";
    }
  }
}

extension NoInternetConnectionHelper on Failure {
  void checkAndTakeAction({required ValueChanged<String>? onError}) {
    if (this is NoInternetFailure) {
      "no_internet".show();
    }
  }
}

extension FormatTimeStamp on int {
  String getCreatedAt() {
    if (this == 0) {
      final currentTime = DateTime.now();
      final current = DateFormat('MM/dd/yyyy').format(currentTime);
      return current;
    }

    final dateTime = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    final current = DateFormat('MM/dd/yyyy').format(dateTime);
    return current;
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

extension ValueConverter on String {
  double fromBigInt() {
    if (this == "") {
      return 0;
    }
    return BigInt.parse(this).toDouble() / kRoyaltyPrecision;
  }
}

extension TrimStringShort on String {
  String trimStringShort(int minThreshold) {
    if (length > minThreshold) {
      return "${substring(0, 6)}...${substring(length - 6, length)}";
    }
    return this;
  }
}

extension TransactionTypePar on dynamic {
  TransactionType toTransactionTypeEnum() {
    return TransactionType.values.firstWhere((e) => e.toString() == 'AssetType.$this', orElse: () => TransactionType.RECEIVE);
  }
}

extension AssetTypePar on String {
  AssetType toAssetTypeEnum() {
    var value = this;
    if (value == k3DText) {
      value = kThreeDText;
    }

    return AssetType.values.firstWhere((e) => e.toString() == 'AssetType.$value', orElse: () => AssetType.Image);
  }
}

extension TrimString on String {
  String trimString(int minThreshold) {
    if (length > minThreshold) {
      return "${substring(0, 10)}...${substring(length - 9, length)}";
    }
    return this;
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
