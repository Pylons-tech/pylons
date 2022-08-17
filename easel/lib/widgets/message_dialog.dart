import 'package:easel_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageDialog {
  MessageDialog();

  void show(String message, {Widget button = const SizedBox()}) {
    showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: false,
      builder: (ctx) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
          content: Text(message, style: TextStyle(fontSize: 16.sp),),
          actions: [button],
        ),
      ),
    );
  }
}
