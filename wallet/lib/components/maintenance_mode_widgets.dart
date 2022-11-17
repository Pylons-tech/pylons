import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/locale_keys.g.dart';
import '../utils/constants.dart';


class MaintenanceModeBannerWidget extends StatelessWidget {
  const MaintenanceModeBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.kDarkPurple,
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
      child: Text(
        LocaleKeys.maintenance_mode_header.tr(),
        style: TextStyle(
            color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class MaintenanceModeMessageWidget extends StatelessWidget {
  const MaintenanceModeMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 110.h,
      color: AppColors.kMainBG,
      child: Align(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 40.w),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
            color: AppColors.kDarkPurple,
            child: Text(
              LocaleKeys.maintenance_mode_message.tr(),
              style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
