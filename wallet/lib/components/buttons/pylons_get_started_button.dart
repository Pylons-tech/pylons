import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/utils/constants.dart';

class PylonsGetStartedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final ValueNotifier<bool> loader;
  final bool enabled;

  const PylonsGetStartedButton({Key? key, required this.onTap, this.text = "", required this.loader, this.enabled = true}) : super(key: key);

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
                color: isUserAllowedToTap(loading: loading) ? AppColors.kDarkRed : AppColors.kGray.withOpacity(0.3),
                height: 45.h,
                width: 200.w,
                child: Center(
                    child: loading
                        ? SizedBox(
                            width: 25.h,
                            height: 25.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.kDarkRed),
                            ),
                          )
                        : Text(
                            text,
                            style: TextStyle(color: AppColors.kWhite, fontSize: 16.sp, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          )),
              ),
            ),
          );
        });
  }

  bool isUserAllowedToTap({required bool loading}) => enabled && !loading;
}
