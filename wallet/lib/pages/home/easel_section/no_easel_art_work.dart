import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NoEaselArtWork extends StatelessWidget {
  const NoEaselArtWork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<HomeProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        SizedBox(
          height: 40.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Text(
            "creation_list_empty_text".tr(),
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.kBlue),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        CustomPaintButton(
            title: "open_easel".tr(),
            bgColor: AppColors.kBlue,
            width: 200.w,
            onPressed: () async {
              final isAndroidDevice = Theme.of(context).platform == TargetPlatform.android;

              final easelAppInstallLink = isAndroidDevice ? kAndroidEaselInstallLink : kIOSEaselInstallLink;
              final easelAppLink = isAndroidDevice ? kAndroidEaselLink : kIOSEaselLink;

              final isInstalled = await canLaunchUrlString(easelAppLink);

              if (isInstalled) {
                launchUrlString(easelAppLink);
              } else {
                launchUrlString(easelAppInstallLink);
              }
            }),

        const Spacer(),
      ],
    );
  }
}
