import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/utils/image_util.dart';

extension SnackbarToast on String {
  Future show({BuildContext? context}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(
        context ?? navigatorKey.currentState!.overlay!.context);

    scaffoldMessenger
        .showSnackBar(
          SnackBar(
            content: Text(this),
            duration: const Duration(milliseconds: 1500),
          ),
        )
        .closed
        .then((value) => scaffoldMessenger.clearSnackBars());
  }
}

class Loading {
  Loading();

  void dismiss() {
    navigatorKey.currentState?.pop();
  }

  Future showLoading({String? message}) {
    if (navigatorKey.currentState?.overlay == null) {
      return Completer()
          .future; // return a fake future if state is screwy - this only ever happens during testing. todo: eliminate this hack
    }
    return showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: true,
      barrierColor: Colors.white.withOpacity(0),
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: SizedBox(
              height: 100.h,
              width: 100.h,
              child: Image.asset(ImageUtil.LOADING_GIF)),
        ),
      ),
    );
  }
}
