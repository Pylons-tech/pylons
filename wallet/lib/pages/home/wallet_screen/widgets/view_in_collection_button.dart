import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/utils/constants.dart';

class BlueClippedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool enabled;

  const BlueClippedButton(
      {Key? key, required this.onTap, this.text = "", this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: ClipPath(
        clipper: MnemonicClipper(cuttingHeight: 18.h),
        child: Container(
          color: enabled ? AppColors.kDarkPurple : AppColors.kGray.withOpacity(0.3),
          height: 45.h,
          width: 200.w,
          child: Center(
              child: Text(
            text,
            style: TextStyle(
                color: enabled ? AppColors.kWhite : AppColors.kDarkGrey.withOpacity(0.5),
                fontSize: 16.sp),
            textAlign: TextAlign.center,
          )),
        ),
      ),
    );
  }
}
