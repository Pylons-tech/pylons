import 'package:easy_localization/easy_localization.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/screen_responsive.dart';
import 'package:evently/widgets/dialog_clipper.dart';
import 'package:evently/widgets/pylons_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShowWalletInstallDialog {
  BuildContext context;
  String errorMessage;
  String buttonMessage;
  VoidCallback onClose;
  VoidCallback onButtonPressed;

  ShowWalletInstallDialog({required this.context, required this.errorMessage, required this.buttonMessage, required this.onClose, required this.onButtonPressed});

  Future show() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 0,
            backgroundColor: EventlyAppTheme.kTransparent,
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
        color: EventlyAppTheme.kLightRed,
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.h),
            SvgPicture.asset(
              SVGUtils.kAlertIcon,
              height: 30.h,
            ),
            SizedBox(height: 30.h),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
              height: 40.h,
              child: PylonsButton(
                  btnText: buttonMessage,
                  onPressed: () {
                    onButtonPressed();
                    Navigator.of(context).pop();
                  },
                  color: EventlyAppTheme.kBlue),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              child: SizedBox(
                width: 0.35.sw,
                height: 0.09.sw,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "cancel".tr(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14.sp, color: EventlyAppTheme.kWhite, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                onClose();
              },
            ),
            SizedBox(height: 20.h),
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
        child: ColoredBox(
          color: EventlyAppTheme.kLightRed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30.h),
              SvgPicture.asset(
                SVGUtils.kAlertIcon,
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
              SizedBox(height: 30.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
                height: 40.h,
                child: PylonsButton(
                    btnText: buttonMessage,
                    onPressed: () {
                      onButtonPressed();
                      Navigator.of(context).pop();
                    },
                    color: EventlyAppTheme.kBlue),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          "cancel".tr(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16.sp, color: EventlyAppTheme.kWhite, fontWeight: FontWeight.w200),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  onClose();
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
