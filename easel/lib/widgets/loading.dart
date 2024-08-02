import 'dart:async';

import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/easel_app_theme.dart';

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
      barrierColor: Colors.white.withOpacity(0),
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          elevation: 0,
          backgroundColor: EaselAppTheme.kTransparent,
          content: SizedBox(
            height: 100.h,
            width: 100.h,
            child: Image.asset(ImageUtil.LOADING_GIF),
          ),
        ),
      ),
    );
  }
}
