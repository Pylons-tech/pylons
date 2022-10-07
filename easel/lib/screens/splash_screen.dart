import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: kSplashScreenDuration), () {
      onGetStarted();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenResponsive(
      mobileScreen: (context) => buildMobileScreen(context),
      tabletScreen: (BuildContext context) => buildTabletScreen(context),
    ),);
  }

  Widget buildMobileScreen(BuildContext context) {
    return SvgPicture.asset(kSvgSplash, fit: BoxFit.cover);
  }

  Stack buildTabletScreen(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(),
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: SvgPicture.asset(kSvgTabSplash, fit: BoxFit.fill)),
        Positioned(
          top: 0.26.sh,
          left: 0.2.sw,
          right: 0,
          child: SizedBox(
            height: 0.3.sh,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(kSplashTabEasel)),
                SizedBox(height: 10.h),
                Text(
                  "nft_manager".tr(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void populateCoinsAndMoveForward() async {
    context.read<EaselProvider>().populateCoinsIfPylonsNotExists();

    navigatorKey.currentState!.pushReplacementNamed(RouteUtil.kRouteCreatorHub);
  }

  void onGetStarted() {
    var onBoardingComplete = GetIt.I.get<Repository>().getOnBoardingComplete();
    if (!onBoardingComplete) {
      Navigator.of(context).pushNamed(RouteUtil.kRouteTutorial);
      return;
    }

    populateCoinsAndMoveForward();
  }
}
