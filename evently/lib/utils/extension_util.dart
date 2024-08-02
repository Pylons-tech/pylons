import 'package:evently/main.dart';
import 'package:evently/models/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constants.dart';

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
      return double.parse(amount).toStringAsFixed(2);
    } else if (this == kPylonSymbol) {
      return double.parse(amount).toStringAsFixed(0);
    } else {
      return double.parse(amount).toStringAsFixed(2);
    }
  }
}



