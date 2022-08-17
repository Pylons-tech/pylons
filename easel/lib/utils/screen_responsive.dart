import 'package:easel_flutter/main.dart';
import 'package:flutter/material.dart';

class ScreenResponsive extends StatelessWidget {
  final WidgetBuilder mobileScreen;
  final WidgetBuilder tabletScreen;

  const ScreenResponsive({Key? key, required this.mobileScreen, required this.tabletScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return tabletScreen(context);
    }

    return mobileScreen(context);
  }
}
