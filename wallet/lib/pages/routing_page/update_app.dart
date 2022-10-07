import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/data_stores/local_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/remote_config_service/remote_config_service.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/screen_responsive.dart';
import 'package:pylons_wallet/utils/svg_util.dart';
import 'package:url_launcher/url_launcher_string.dart';

TextStyle kUpdateAppSkipText = const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54);

class UpdateApp extends StatefulWidget {
  const UpdateApp({Key? key}) : super(key: key);

  @override
  State<UpdateApp> createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  RemoteConfigService get remoteConfigService => GetIt.I.get();

  WalletsStore get walletsStore => GetIt.I.get();
  Repository get repository => GetIt.I.get();

  ValueNotifier<String> versionInfoNotifier = ValueNotifier('');

  @override
  void initState() {
    super.initState();

    repository.logUserJourney(screenName: AnalyticsScreenEvents.updateApp);

    String remoteConfigVersion;
    if (Platform.isAndroid) {
      remoteConfigVersion = remoteConfigService.getAndroidAppVersion();
    } else {
      remoteConfigVersion = remoteConfigService.getIOSAppVersion();
    }

    versionInfoNotifier.value = "v$remoteConfigVersion";
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          backgroundColor: AppColors.kWhite01,
          body: ScreenResponsive(
            tabletScreen: (BuildContext context) => buildTabletScreen(context),
            mobileScreen: (BuildContext context) => buildMobileScreen(context),
          )),
    );
  }

  Stack buildTabletScreen(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
            child: ColoredBox(
          color: Colors.white,
        )),
        Positioned(left: 0, right: 0, top: 0, bottom: 0, child: SvgPicture.asset(SVGUtil.UPDATE_NOW_IPAD_BACKGROUND, fit: BoxFit.fill)),
        Positioned(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 0.1.sw,
                height: 0.2.sh,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.asset(ImageUtil.UPDATE_APP_ICON),
                ),
              ),
              SizedBox(height: 35.h),
              SvgPicture.asset(SVGUtil.UPDATE_AVAILABLE_CAPTION),
              SizedBox(
                height: 40.h,
              ),
              ValueListenableBuilder(
                  valueListenable: versionInfoNotifier,
                  builder: (_, __, ___) {
                    return Text(
                      '$__',
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      textAlign: TextAlign.center,
                    );
                  }),
              SizedBox(
                height: 40.h,
              ),
              Text(
                "update_available_desc".tr(),
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              )
            ],
          ),
        )),
        Positioned(
            height: 40.h,
            left: 0,
            right: 0,
            bottom: 60.h,
            child: Stack(
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: InkWell(
                        onTap: () {
                          final platform = Theme.of(context).platform;

                          if (platform == TargetPlatform.android) {
                            launchPlayStore();
                          } else {
                            launchAppStore();
                          }
                        },
                        child: SvgPicture.asset(SVGUtil.BUTTON_BACKGROUND))),
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Center(
                        child: Text(
                          "update_now".tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ))
              ],
            )),
        Positioned(
          left: 0,
          right: 0,
          bottom: 20.h,
          child: InkWell(
              onTap: () {
                _loadWallets();
              },
              child: Text(
                "skip".tr(),
                textAlign: TextAlign.center,
                style: kUpdateAppSkipText,
              )),
        )
      ],
    );
  }

  Stack buildMobileScreen(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: SvgPicture.asset(SVGUtil.UPDATE_NOW_BACKGROUND, fit: BoxFit.cover),
        ),
        Positioned(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 0.51.sw,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.asset(ImageUtil.UPDATE_APP_ICON),
                ),
              ),
              SizedBox(height: 35.h),
              SvgPicture.asset(SVGUtil.UPDATE_AVAILABLE_CAPTION),
              SizedBox(
                height: 40.h,
              ),
              ValueListenableBuilder(
                  valueListenable: versionInfoNotifier,
                  builder: (_, __, ___) {
                    return Text(
                      '$__',
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    );
                  }),
              SizedBox(
                height: 40.h,
              ),
              Text(
                "update_available_desc".tr(),
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              )
            ],
          ),
        )),
        Positioned(
            height: 40.h,
            left: 0,
            right: 0,
            bottom: 70,
            child: Stack(
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: InkWell(
                        onTap: () {
                          final platform = Theme.of(context).platform;

                          if (platform == TargetPlatform.android) {
                            launchPlayStore();
                          } else {
                            launchAppStore();
                          }
                        },
                        child: SvgPicture.asset(SVGUtil.BUTTON_BACKGROUND))),
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "update_now".tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ))
              ],
            )),
        Positioned(
          left: 0,
          right: 0,
          bottom: 20.h,
          child: InkWell(
              onTap: () {
                _loadWallets();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "skip".tr(),
                  textAlign: TextAlign.center,
                  style: kUpdateAppSkipText,
                ),
              )),
        )
      ],
    );
  }

  Future<void> _loadWallets() async {
    await sl<LocalDataSource>().clearDataOnIosUnInstall();
    await walletsStore.loadWallets();

    if (walletsStore.getWallets().value.isEmpty) {
      //Loads the last used wallet.
      Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamed(RouteUtil.ROUTE_ONBOARDING);
    } else {
      // Assigning the latest wallet to the app.
      Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamed(RouteUtil.ROUTE_HOME);
    }
  }

  void launchPlayStore() {
    _launchURL(kAndroidAppLink);
  }

  void launchAppStore() {
    _launchURL(kIOSAppLink);
  }

  Future _launchURL(String url) async => await canLaunchUrlString(url) ? await launchUrlString(url) : throw '${"could_not_launch".tr()} $url';
}
