import 'package:evently/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
