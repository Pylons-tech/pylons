import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/pages/settings/widgets/delete_dialog.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

TextStyle kHeadingTextStyle = TextStyle(
    fontSize: isTablet ? 23.sp : 27.sp,
    fontFamily: 'UniversalSans',
    color: AppColors.kWhite,
    fontWeight: FontWeight.w700);

TextStyle kMsgTextStyle = TextStyle(
    fontSize: isTablet ? 12.sp : 14.sp,
    fontFamily: 'UniversalSans',
    color: AppColors.kWhite,
    fontWeight: FontWeight.w700);

class InsufficientBalanceDialog {
  final BuildContext context;

  InsufficientBalanceDialog(this.context);

  Future show() {
    return showDialog(
        barrierColor: Colors.black38,
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            elevation: 0,
            insetPadding:
                EdgeInsets.symmetric(horizontal: isTablet ? 54.w : 15.w),
            backgroundColor: Colors.transparent,
            child: ClipPath(
              clipper: DialogClipper(),
              child: Container(
                color: AppColors.kDarkRed.withOpacity(0.8),
                padding:
                    EdgeInsets.symmetric(horizontal: isTablet ? 32.w : 36.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),

                    Align(
                      child: SvgPicture.asset(
                        SVGUtil.ALERTDIALOG,
                        height: 40.h,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(
                      height: 20.h,
                    ),

                    Text(
                      "insufficient_balance".tr(),
                      textAlign: TextAlign.center,
                      style: kHeadingTextStyle,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),

                    Text(
                      "insufficient_balance_msg".tr(),
                      style: kMsgTextStyle,
                    ),

                    SizedBox(
                      height: 50.h,
                    ),
                    SizedBox(
                      height: 45.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: buildButton(
                                  title: "add_pylons".tr(),
                                  bgColor: AppColors.kTextBlackColor,
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .pushNamed(RouteUtil.ROUTE_ADD_PYLON);
                                  })),
                          Expanded(
                            child: TextButton(
                                onPressed: Navigator.of(context).pop,
                                child: Text(
                                  "cancel".tr(),
                                  style: TextStyle(
                                      color: AppColors.kWhite,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 40.h,
                    ),
                    //   const Spacer(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildButton(
      {required String title,
      required Color bgColor,
      required Function onPressed}) {
    return InkWell(
      onTap: () => onPressed(),
      child: CustomPaint(
        painter: BoxShadowPainter(cuttingHeight: 18.h),
        child: ClipPath(
          clipper: MnemonicClipper(cuttingHeight: 18.h),
          child: Container(
            color: bgColor,
            height: 45.h,
            width: 200.w,
            child: Center(
                child: Text(
              title,
              style: TextStyle(
                  color: AppColors.kWhite,
                  fontSize: isTablet ? 14.sp : 16.sp,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            )),
          ),
        ),
      ),
    );
  }
}
