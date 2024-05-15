import 'dart:async';

import 'package:evently/evently_provider.dart';
import 'package:evently/main.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class LoadingProgress {
  LoadingProgress();

  void dismiss() {
    navigatorKey.currentState?.pop();
  }

  final EventlyProvider easelProvider = GetIt.I.get<EventlyProvider>();

  Future showLoadingWithProgress({String? message}) {
    if (navigatorKey.currentState?.overlay == null) {
      return Completer()
          .future; // return a fake future if state is screwy - this only ever happens during testing. todo: eliminate this hack
    }
    return showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: true,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          elevation: 0,
          backgroundColor: EventlyAppTheme.kTransparent,
          content: SizedBox(
            width: 100.w,
            height: 100.h,
            child: Image.asset(ImageUtil.LOADING_GIF),
          ),
        ),
      ),
    );
  }
}
