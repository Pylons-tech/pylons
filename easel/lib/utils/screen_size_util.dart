import 'package:flutter/material.dart';

class ScreenSizeUtil {
  final BuildContext context;

  ScreenSizeUtil(this.context);

  double width({int percent = 100}) => MediaQuery.of(context).size.width * (percent / 100);

  double height({int percent = 100}) => MediaQuery.of(context).size.height * (percent / 100);

}