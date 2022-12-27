import 'package:flutter/material.dart';

class PylonsLoadingAnimation {
  PylonsLoadingAnimation({
    required this.context,
    double height = 100,
    double width = 100,
  })  : _height = height,
        _width = width;

  Future show() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.white.withOpacity(0),
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: SizedBox(height: _height, width: _width, child: Image.asset('assets/loading.gif', package: 'pylons_sdk',)),
        ),
      ),
    );
  }

  void hide() {
    Navigator.of(context).pop();
  }

  final BuildContext context;
  final double _height;
  final double _width;
}
