import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenResponsive(
      mobileScreen: (context) => buildMobileScreen(context),
      tabletScreen: (BuildContext context) => buildTabletScreen(context),
    ));
  }

  Stack buildMobileScreen(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: SvgPicture.asset(kSvgSplash, fit: BoxFit.cover)),
        Positioned(
          top: 0.3.sh,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            child: PylonsButton(
              onPressed: onGetStartedPressed,
              btnText: kGetStarted,
              color: EaselAppTheme.kBlue,
            ),
          ),
        ),
      ],
    );
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
                Align(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(kSplashNFTCreatorTab)),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0.3.sh,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            child: PylonsButton(
              onPressed: onGetStartedPressed,
              btnText: kGetStarted,
              color: EaselAppTheme.kBlue,
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

  void onGetStartedPressed() {
    var onBoardingComplete = GetIt.I.get<Repository>().getOnBoardingComplete();
    if (!onBoardingComplete) {
      Navigator.of(context).pushNamed(RouteUtil.kRouteTutorial);
      return;
    }

    populateCoinsAndMoveForward();
  }
}
