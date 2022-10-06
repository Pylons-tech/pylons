import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NoInternetDialog {
  bool _isShowing = false;

  NoInternetDialog();

  void dismiss() {
    navigatorKey.currentState?.pop();
    setIsShowing = false;
  }

  bool get isShowing => _isShowing;

  set setIsShowing(bool value) {
    _isShowing = value;
  }

  Future showNoInternet() async {
    if (navigatorKey.currentState == null || navigatorKey.currentState!.overlay == null) {
      return;
    }

    return showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: true,
      barrierColor: Colors.white.withOpacity(0),
      builder: (ctx) {
        setIsShowing = true;
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(3.0.h),
          content: buildView(),
        );
      },
    );
  }

  Widget buildView() {
    return ClipPath(
      clipper: ContainerCornerClipper(),
      child: Container(
        width: 400.w,
        height: 300.w,
        color: AppColors.kDarkRed.withOpacity(0.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            SvgPicture.asset(
              kAlertIcon,
              height: 30.h,
            ),
            SizedBox(height: 30.h),
            Text(
              NETWORK_ERROR,
              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 20.h),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "no_internet_connection".tr(),
                        style: Theme.of(navigatorKey.currentState!.context).textTheme.bodyText2!.copyWith(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                      ),
                      TextSpan(
                          text: email,
                          style: Theme.of(navigatorKey.currentState!.context).textTheme.bodyText2!.copyWith(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchEmail();
                            }),
                    ],
                  ),
                )),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: SizedBox(
                    width: 0.3.sw,
                    height: 0.09.sw,
                    child: Center(
                      child: Text(
                        "cancel".tr(),
                        style: Theme.of(navigatorKey.currentState!.context).textTheme.bodyText1!.copyWith(fontSize: 16.sp, color: AppColors.kWhite, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(navigatorKey.currentState!.context);
                    setIsShowing = false;
                  },
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget buildBackupButton({required String title, required Color bgColor, required VoidCallback onPressed}) {
    return InkWell(
      onTap: () {
        onPressed.call();
      },
      child: CustomPaint(
        painter: BoxShadowPainter(cuttingHeight: 18.h),
        child: ClipPath(
          clipper: MnemonicClipper(cuttingHeight: 18.h),
          child: Container(
            color: bgColor,
            height: 45.h,
            width: 130.w,
            child: Center(
                child: Text(
              title,
              style: TextStyle(color: bgColor == AppColors.kButtonColor ? AppColors.kBlue : AppColors.kWhite, fontSize: 16.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            )),
          ),
        ),
      ),
    );
  }

  Future _launchEmail() async {
    if (await canLaunchUrl(Uri.parse("$mailto:$email"))) {
      await launchUrl(Uri.parse("$mailto:$email"));
    } else {
      throw 'Could not launch';
    }
  }
}

class ContainerCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final oneThirdHeight = size.height / 3.0;
    final oneThirdWidth = size.width / 3.0;
    final Path path0 = Path()
      ..lineTo(0, size.height)
      ..lineTo(oneThirdWidth * 2 + size.width * 0.16, size.height)
      ..lineTo(size.width, oneThirdHeight * 2 + size.width * 0.13)
      ..lineTo(size.width, 0)
      ..lineTo(oneThirdWidth * 2, 0.0)
      ..lineTo(oneThirdWidth / 3 + size.width * 0.08, 0.0)
      ..lineTo(0.0, oneThirdHeight / 3 + size.width * 0.08)
      ..close();

    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
