import 'package:flutter/material.dart';
import 'package:pylons_wallet/main_prod.dart';

class ScreenResponsive extends StatelessWidget {
  final WidgetBuilder mobileScreen;
  final WidgetBuilder tabletScreen;

  const ScreenResponsive(
      {super.key, required this.mobileScreen, required this.tabletScreen});

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return tabletScreen(context);
    }

    return mobileScreen(context);
  }
}
