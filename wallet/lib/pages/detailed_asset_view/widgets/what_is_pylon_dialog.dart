import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;

TextStyle _rowTitleTextStyle = TextStyle(color: AppColors.kWhite, fontWeight: FontWeight.w800, fontSize: isTablet ? 14.sp : 12.sp);
TextStyle _rowSubtitleTextStyle = TextStyle(
  color: AppColors.kWhite,
  fontSize: isTablet ? 12.sp : 10.sp,
);

class WhatIsPylonDialog {
  final BuildContext _buildContext;
  final VoidCallback onBackPressed;

  WhatIsPylonDialog({required BuildContext context, required this.onBackPressed}) : _buildContext = context;

  void show() {
    showDialog(
      context: _buildContext,
      builder: (context) {
        return Dialog(backgroundColor: Colors.transparent, alignment: Alignment.lerp(Alignment.center, Alignment.bottomCenter, 0.15), child: const WhatIsPylonWidget());
      },
      barrierColor: Colors.transparent,
    );
  }
}

class WhatIsPylonWidget extends StatefulWidget {
  const WhatIsPylonWidget({Key? key}) : super(key: key);

  @override
  State<WhatIsPylonWidget> createState() => _WhatIsPylonWidgetState();
}

class _WhatIsPylonWidgetState extends State<WhatIsPylonWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WhatIsPylonBoxClipper(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          height: 240.h,
          margin: EdgeInsets.zero,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 60,
                  width: 80,
                  child: ClipPath(
                    clipper: RightTriangleClipper(orientation: enums.Orientation.Orientation_NW),
                    child: ColoredBox(
                      color: AppColors.kDarkRed,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                  height: 60,
                  width: 80,
                  child: ClipPath(
                    clipper: RightTriangleClipper(orientation: enums.Orientation.Orientation_SE),
                    child: ColoredBox(
                      color: AppColors.kDarkRed,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.w : 30.w),
                      child: Text(
                        "what_is_pylon".tr(),
                        style: _rowTitleTextStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.w : 30.w),
                      child: Text(
                        "what_is_pylon_info".tr(),
                        style: _rowSubtitleTextStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Center(
                      child: ClipPath(
                        clipper: WhatIsPylonButtonClipper(),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 120.r,
                            height: 30.h,
                            color: AppColors.kPayNowBackgroundGrey.withOpacity(0.2),
                            child: Center(
                              child: Text(
                                "close".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.kUnselectedIcon, fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WhatIsPylonBoxClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WhatIsPylonButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width - 18, size.height);
    path.lineTo(size.width, size.height - 18);
    path.lineTo(size.width, 0);
    path.lineTo(18, 0);
    path.lineTo(0, 18);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
