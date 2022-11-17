import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../utils/svg_util.dart';

class NoEaselArtWork extends StatelessWidget {
  const NoEaselArtWork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<HomeProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w,),
          child: Text(
            LocaleKeys.creation_list_empty_text.tr(),
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.kGreyColor),
            textAlign: TextAlign.start,
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w,),
          child: FutureBuilder<Column>(
            future: _getButtonForEasel(context: context),
            builder: (context,snapshot){
              return snapshot.data??const SizedBox();
            },
          ),
        ),
        SizedBox(height: 50.h,),
      ],
    );
  }

  Future<Column> _getButtonForEasel({required BuildContext context})async{
    final isAndroidDevice = Theme.of(context).platform == TargetPlatform.android;

    final easelAppInstallLink = isAndroidDevice ? kAndroidEaselInstallLink : kIOSEaselInstallLink;
    final easelAppLink = isAndroidDevice ? kAndroidEaselLink : kIOSEaselLink;

    final isInstalled = await canLaunchUrlString(easelAppLink);
    return Column(
      children: [
        SizedBox(
          height: 45.h,
          child: Card(
            elevation: 0,
            shadowColor: Colors.black12,
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    SVGUtil.DOWNLOAD_EASEL_TOOLTIP_BG,
                    width: isTablet?400.w:350.w,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0.h),
                  child: Text(
                    LocaleKeys.create_easel_free_nft.tr(),
                    style: TextStyle(color: AppColors.kBlue , fontSize: 12.sp, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 3.h,),
        CustomPaintButton(
            title: isInstalled?LocaleKeys.open_easel.tr():LocaleKeys.download_easel.tr(),
            bgColor: AppColors.kBlue,
            width: double.maxFinite,
            onPressed: () async {
              if (isInstalled) {
                launchUrlString(easelAppLink);
              } else {
                launchUrlString(easelAppInstallLink);
              }
            }),
      ],
    );
  }

}
