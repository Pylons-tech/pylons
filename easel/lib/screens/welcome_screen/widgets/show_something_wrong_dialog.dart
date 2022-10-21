import 'package:easel_flutter/screens/welcome_screen/widgets/common/dialog_clipper.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import '../../../utils/constants.dart';

class ShowSomethingWentWrongDialog {
  BuildContext context;
  String errorMessage;
  VoidCallback onClose;

  ShowSomethingWentWrongDialog({required this.context, required this.errorMessage, required this.onClose});

  Future show() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: ScreenResponsive(
              mobileScreen: (context) => buildMobile(context),
              tabletScreen: (context) => buildTablet(context),
            ),
          );
        });
  }

  ClipPath buildMobile(BuildContext context) {
    return ClipPath(
      clipper: DialogClipper(),
      child: Container(
        color: EaselAppTheme.kLightRed,
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.h),
            SvgPicture.asset(
              PngUtils.kAlertIcon,
              height: 30.h,
            ),
            SizedBox(height: 30.h),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            GestureDetector(
              child: SizedBox(
                width: 0.35.sw,
                height: 0.09.sw,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: SizedBox(width: 130.w, child: SvgPicture.asset(SVGUtils.kSvgCloseButton, fit: BoxFit.cover)),
                      ),
                    ),
                    Center(
                      child: Text(
                        "close".tr(),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16.sp, color: EaselAppTheme.kWhite, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                onClose();
              },
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Padding buildTablet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
      child: ClipPath(
        clipper: DialogClipper(),
        child: Container(
          color: EaselAppTheme.kLightRed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30.h),
              SvgPicture.asset(
                PngUtils.kAlertIcon,
                height: 30.h,
              ),
              SizedBox(height: 30.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0.09.sw),
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40.h),
              GestureDetector(
                child: SizedBox(
                  width: 0.35.sw,
                  height: 0.09.sw,
                  child: Stack(
                    children: [
                      Positioned(left: 0, right: 0, top: 0, bottom: 0, child: Center(child: SizedBox(width: 130.w, child: SvgPicture.asset(SVGUtils.kSvgCloseButton, fit: BoxFit.cover)))),
                      Center(
                        child: Text(
                          "close".tr(),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16.sp, color: EaselAppTheme.kWhite, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  onClose();
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onDownloadNowPressed(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final appAlreadyInstalled = await PylonsWallet.instance.exists();
    if (!appAlreadyInstalled) {
      PylonsWallet.instance.goToInstall();
    } else {
      scaffoldMessenger.show(message: "pylons_already_installed".tr());
    }
  }
}
