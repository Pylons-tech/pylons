import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

TextStyle kDeleteHeaderTextStyle = TextStyle(fontSize: 14.sp, fontFamily: 'UniversalSans', color: AppColors.kWhite, fontWeight: FontWeight.w500);

class DeleteDialog {
  final BuildContext context;

  DeleteDialog(this.context);

  Future show() {
    return showDialog(
        barrierColor: Colors.black38,
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? 45.w : 15.w),
            backgroundColor: Colors.transparent,
            child: ClipPath(
              clipper: DialogClipper(),
              child: Container(
                color: AppColors.kDarkRed,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),

                    Align(
                      child: SvgPicture.asset(
                        SVGUtil.ALERTDIALOG,
                        height: 40.h,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(
                      height: 35.h,
                    ),

                    Text(
                      "are_you_sure_you_want_to_delete_your_wallet",
                      textAlign: TextAlign.center,
                      style: kDeleteHeaderTextStyle,
                    ).tr(),

                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      height: 40.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: buildButton(
                                  title: "yes",
                                  bgColor: AppColors.kBlue,
                                  onPressed: () async {
                                    final navigator = Navigator.of(context);

                                    final selectedEnvResponse = GetIt.I.get<Repository>().getNetworkEnvironmentPreference();

                                    if (selectedEnvResponse.isLeft()) {
                                      navigator.pop();
                                      return;
                                    }

                                    final deleteResponse = await GetIt.I.get<WalletsStore>().deleteAccounts();

                                    if (isDeletionNotSuccessful(deleteResponse: deleteResponse)) {
                                      navigator.pop();
                                      return;
                                    }

                                    await GetIt.I.get<Repository>().saveNetworkEnvironmentPreference(networkEnvironment: selectedEnvResponse.getOrElse(() => ''));
                                    navigator.pushNamedAndRemoveUntil(RouteUtil.ROUTE_ONBOARDING, (route) => false);
                                  })),
                          SizedBox(
                            width: 15.w,
                          ),
                          Expanded(
                            child: buildButton(title: "no", bgColor: AppColors.kWhite.withOpacity(0.3), onPressed: Navigator.of(context).pop),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 30.h,
                    ),
                    //   const Spacer(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool isDeletionNotSuccessful({required bool deleteResponse}) => !deleteResponse;

  Widget buildButton({required String title, required Color bgColor, required Function onPressed}) {
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
              title.tr(),
              style: TextStyle(color: bgColor == AppColors.kButtonColor ? AppColors.kBlue : AppColors.kWhite, fontSize: 16.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            )),
          ),
        ),
      ),
    );
  }
}

class DialogClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width - 65.h, size.height);
    path.lineTo(size.width, size.height - 65.h);
    path.lineTo(size.width, 0);
    path.lineTo(65.h, 0);
    path.lineTo(0, 65.h);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
