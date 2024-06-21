import 'package:evently/main.dart';
import 'package:flutter/material.dart';

class ScreenResponsive extends StatelessWidget {
  final WidgetBuilder mobileScreen;
  final WidgetBuilder tabletScreen;

  const ScreenResponsive({super.key, required this.mobileScreen, required this.tabletScreen});

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return tabletScreen(context);
    }

    return mobileScreen(context);
  }
}
