import 'dart:async';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../utils/easel_app_theme.dart';

class LoadingProgress {
  LoadingProgress();

  void dismiss() {
    navigatorKey.currentState?.pop();
  }

  final EaselProvider easelProvider = GetIt.I.get<EaselProvider>();

  Future showLoadingWithProgress({String? message}) {
    if (navigatorKey.currentState?.overlay == null) {
      return Completer()
          .future; // return a fake future if state is screwy - this only ever happens during testing. todo: eliminate this hack
    }
    return showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: true,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          elevation: 0,
          backgroundColor: EaselAppTheme.kTransparent,
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
