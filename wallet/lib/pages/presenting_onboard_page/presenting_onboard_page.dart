import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/gen/assets.gen.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/route_util.dart';

import '../../generated/locale_keys.g.dart';

class PresentingOnboardPage extends StatefulWidget {
  const PresentingOnboardPage({super.key});

  @override
  State<PresentingOnboardPage> createState() => __PresentingOnboardPageState();
}

TextStyle kSubHeadlineTextStyle = TextStyle(fontSize: 30.sp, fontFamily: kUniversalFontFamily, color: AppColors.kBlack, fontWeight: FontWeight.w600);

class __PresentingOnboardPageState extends State<PresentingOnboardPage> {
  Repository get repository => GetIt.I.get();

  @override
  void initState() {
    super.initState();

    repository.logUserJourney(screenName: AnalyticsScreenEvents.mainLanding);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.kWhite,
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: SvgPicture.asset(
                Assets.images.svg.mainScreenBackground,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.images.icons.pylonsLogoSvg,
                          fit: BoxFit.cover,
                        ),
                        HorizontalSpace(20.w),
                        SvgPicture.asset(
                          Assets.images.svg.pylon,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    VerticalSpace(5.h),
                    Text(
                      LocaleKeys.stake_your_digital_claim.tr(),
                      style: TextStyle(fontSize: 26.sp, fontFamily: kUniversalFontFamily, color: AppColors.kBlack, fontWeight: FontWeight.w700),
                    ),
                    VerticalSpace(100.h),
                    buildBackupButton(
                        title: LocaleKeys.create_wallet.tr(),
                        bgColor: AppColors.kCreateWalletButtonColorDark,
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.createWallet.name);
                        }),
                    VerticalSpace(25.h),
                    buildBackupButton(
                        title: LocaleKeys.restore_wallet.tr(),
                        bgColor: AppColors.kButtonColor,
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.restoreWallet.name);
                        }),
                    VerticalSpace(25.h),
                  ],
                ),
              ),
            )
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
            width: 200.w,
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
}
