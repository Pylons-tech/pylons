import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/main.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/route_util.dart';
import 'package:evently/widgets/clipped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventHubScreen extends StatefulWidget {
  const EventHubScreen({super.key});

  @override
  State<EventHubScreen> createState() => _EventHubScreenState();
}

class _EventHubScreenState extends State<EventHubScreen> {
  TextStyle headingStyle = TextStyle(
    fontSize: isTablet ? 20.sp : 20.sp,
    fontWeight: FontWeight.w800,
    color: EventlyAppTheme.kLightPurple,
    fontFamily: kUniversalFontFamily,
  );
  TextStyle titleStyle = TextStyle(
    fontSize: isTablet ? 14.sp : 14.sp,
    fontWeight: FontWeight.w700,
    color: EventlyAppTheme.kWhite,
    fontFamily: kUniversalFontFamily,
  );
  TextStyle btnTxtStyle = TextStyle(
    fontSize: isTablet ? 12.sp : 12.sp,
    fontWeight: FontWeight.w700,
    color: EventlyAppTheme.kWhite,
    fontFamily: kUniversalFontFamily,
  );

  TextStyle subTitleStyle = TextStyle(
    fontSize: isTablet ? 12.sp : 12.sp,
    fontWeight: FontWeight.w700,
    color: EventlyAppTheme.kLightText,
    fontFamily: kUniversalFontFamily,
  );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EventlyAppTheme.kBlack,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: EventlyAppTheme.kBlack,
          body: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40.h,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pushNamed(RouteUtil.kCreateEvent),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: EventlyAppTheme.kpurpleDark,
                            boxShadow: [BoxShadow(color: EventlyAppTheme.kpurpleDark.withOpacity(0.6), blurRadius: 8.0)],
                          ),
                          child: Icon(Icons.add, size: 27.h, color: EventlyAppTheme.kWhite),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    LocaleKeys.eventhub.tr(),
                    style: headingStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    LocaleKeys.welcome_event.tr(),
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getButton(title: LocaleKeys.draft),
                      getButton(title: LocaleKeys.for_sale),
                      getButton(title: LocaleKeys.history),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        LocaleKeys.no_nft_created.tr(),
                        style: subTitleStyle,
                      )),
                ),
                const Spacer(),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20.w), child: getCreateEventWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getButton({required String title}) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(border: Border.all(color: EventlyAppTheme.kWhite)),
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        child: Text(
          title.tr(),
          style: btnTxtStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget getCreateEventWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: ClippedButton(
        title: LocaleKeys.create_event.tr(),
        bgColor: EventlyAppTheme.kBlue,
        textColor: EventlyAppTheme.kWhite,
        onPressed: () {
          Navigator.of(context).pushNamed(RouteUtil.kCreateEvent);
        },
        cuttingHeight: 15.h,
        clipperType: ClipperType.bottomLeftTopRight,
        isShadow: false,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }
}
