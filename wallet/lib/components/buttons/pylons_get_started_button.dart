import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/utils/constants.dart';

class PylonsGetStartedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final ValueNotifier<bool> loader;
  final bool enabled;
  final Color textColor;
  final Color btnUnselectBGColor;
  final FontWeight fontWeight;
  final double btnHeight;
  final double btnWidth;
  final double fontSize;

  const PylonsGetStartedButton({
    Key? key,
    required this.onTap,
    this.text = "",
    required this.loader,
    this.enabled = true,
    this.textColor = AppColors.kButtonColor,
    this.fontWeight = FontWeight.w600,
    this.btnUnselectBGColor = AppColors.kGreyColorBtn,
    this.btnHeight = 45,
    this.btnWidth = 200,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: loader,
        builder: (context, loading, child) {
          return InkWell(
            onTap: isUserAllowedToTap(loading: loading) ? onTap : null,
            child: ClipPath(
              clipper: MnemonicClipper(cuttingHeight: 18.h),
              child: Container(
                color: isUserAllowedToTap(loading: loading) ? AppColors.kDarkRed : btnUnselectBGColor,
                height: btnHeight.h,
                width: btnWidth.w,
                child: Center(
                  child: loading
                      ? SizedBox(
                          width: 25.r,
                          height: 25.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.kDarkRed),
                          ),
                        )
                      : Text(
                          text,
                          style: TextStyle(color: textColor, fontSize: fontSize.sp, fontWeight: fontWeight),
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            ),
          );
        });
  }

  bool isUserAllowedToTap({required bool loading}) => enabled && !loading;
}
