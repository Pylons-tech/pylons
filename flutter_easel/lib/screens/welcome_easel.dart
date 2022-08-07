import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/clipped_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class WelcomeEasel extends StatefulWidget {
  const WelcomeEasel({Key? key}) : super(key: key);

  @override
  State<WelcomeEasel> createState() => _WelcomeEaselState();
}

class _WelcomeEaselState extends State<WelcomeEasel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EaselAppTheme.kLightWhiteBackground,
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 40.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80.h,),
            Text(
              "welcome_to_easel".tr(),
              style: TextStyle(color: EaselAppTheme.kBlack, fontSize: 20.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 50.h,),
            Text(
              "easel_is_tool".tr(),
              style: TextStyle(
                color: EaselAppTheme.kBlack,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 30.h,),

            Text(
              "after_you_successfully".tr(),
              style: TextStyle(
                color: EaselAppTheme.kBlack,
                fontSize: 14.sp,

              ),
            ),
            SizedBox(height: 30.h,),

            Text(
              "once_you_press".tr(),
              style: TextStyle(
                color: EaselAppTheme.kBlack,
                fontSize: 14.sp,

              ),
            ),
            SizedBox(height: 180.h,),
            ClippedButton(
              title: "start".tr(),
              bgColor: EaselAppTheme.kBlue,
              textColor: EaselAppTheme.kWhite,
              onPressed: () {
                populateCoinsAndMoveForward();
              },
              cuttingHeight: 15.h,
              clipperType: ClipperType.bottomLeftTopRight,
              isShadow: false,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  void populateCoinsAndMoveForward() async {
    GetIt.I.get<Repository>().saveOnBoardingComplete();
    context.read<EaselProvider>().populateCoinsIfPylonsNotExists();

    navigatorKey.currentState!.pushReplacementNamed(RouteUtil.kRouteCreatorHub);
  }
}
