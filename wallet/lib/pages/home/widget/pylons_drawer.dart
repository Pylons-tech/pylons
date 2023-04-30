import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/gen/assets.gen.dart';
import 'package:pylons_wallet/generated/locale_keys.g.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/pages/settings/widgets/delete_dialog.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/route_util.dart';

class PylonsDrawer extends StatelessWidget {
  const PylonsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.43.sw,
      child: Drawer(
        backgroundColor: AppColors.kBlack87.withOpacity(0.7),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                CircleAvatar(
                  backgroundColor: AppColors.kMainBG,
                  radius: 34.r,
                  child: UserAvatarWidget(
                    radius: 35.r,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                /// Revert when the functionality is added
                // DrawerTile(
                //   LocaleKeys.edit_profile.tr(),
                //   width: 75,
                //   textAlign: TextAlign.center,
                //   onPressed: () {},
                // ),
                DrawerTile(
                  LocaleKeys.general.tr(),
                  height: 60,
                  width: isTablet ? 60 : 85,
                  icon: Assets.images.svg.settingsGeneral,
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteUtil.ROUTE_GENERAL);
                  },
                ),
                /// Revert when the functionality is added
                // DrawerTile(
                //   LocaleKeys.cash_out.tr(),
                //   height: 60,
                //   width: isTablet ? 60 : 85,
                //   icon: SVGUtil.DRAWER_CASH_OUT,
                //   onPressed: () {},
                // ),
                // DrawerTile(
                //   LocaleKeys.history.tr(),
                //   height: 60,
                //   width: isTablet ? 60 : 85,
                //   icon: SVGUtil.DRAWER_HISTORY,
                //   onPressed: () {},
                // ),
                DrawerTile(
                  LocaleKeys.recovery.tr(),
                  height: 60,
                  width: isTablet ? 60 : 85,
                  icon: Assets.images.svg.settingsRecovery,
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteUtil.ROUTE_RECOVERY);
                  },
                ),
                DrawerTile(
                  LocaleKeys.legal.tr(),
                  height: 60,
                  width: isTablet ? 60 : 85,
                  icon: Assets.images.svg.settingsLegal,
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteUtil.ROUTE_LEGAL);
                  },
                ),
                const Spacer(),
                DrawerTile(
                  LocaleKeys.delete_wallet.tr(),
                  height: 60,
                  width: isTablet ? 70 : 100,
                  icon: Assets.images.svg.settingsDelete,
                  iconColor: AppColors.kDarkRed,
                  onPressed: () {
                    final DeleteDialog deleteDialog = DeleteDialog(context);
                    deleteDialog.show();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final String? icon;
  final Color iconColor;
  final TextAlign textAlign;

  const DrawerTile(
    this.title, {
    Key? key,
    required this.onPressed,
    this.height = 45,
    this.width = 85,
    this.icon,
    this.iconColor = AppColors.kWhite,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: AppColors.kWhite.withOpacity(0.3),
      child: SizedBox(
        width: double.infinity,
        height: height.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              SvgPicture.asset(
                icon!,
                color: iconColor,
                width: 18.r,
                height: 18.r,
              )
            else
              const SizedBox(),
            SizedBox(
              width: icon != null ? 10.0.w : 0,
            ),
            SizedBox(
              width: width.w,
              child: Text(
                title,
                textAlign: textAlign,
                style: TextStyle(
                  color: AppColors.kWhite,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
