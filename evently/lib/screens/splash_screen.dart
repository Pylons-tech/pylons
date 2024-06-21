import 'package:evently/main.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/route_util.dart';
import 'package:evently/utils/screen_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: kSplashScreenDuration), () {
      navigatorKey.currentState!.pushReplacementNamed(RouteUtil.kRouteEventHub);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenResponsive(
        mobileScreen: (BuildContext context) => buildMobileScreen(context),
        tabletScreen: (BuildContext context) => buildMobileScreen(context),
      ),
    );
  }

  Widget buildMobileScreen(BuildContext context) {
    return SvgPicture.asset(SVGUtils.kSvgSplash, fit: BoxFit.cover);
  }
}
