import 'package:flutter/cupertino.dart';

class ScreenSizeUtil{
  final BuildContext context;

  ScreenSizeUtil(this.context);

  double width({double percent = 1}) => MediaQuery.of(context).size.width * percent;
  double height({double percent = 1}) => MediaQuery.of(context).size.height * percent;

}