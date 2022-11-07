import 'dart:async';
import 'dart:io';
import 'package:cosmos_utils/app_info_extractor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/pages/settings/utils/user_info_provider.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/data_stores/local_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/remote_config_service/remote_config_service.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/route_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Timer timer;

  WalletsStore get walletsStore => GetIt.I.get();

  RemoteConfigService get remoteConfigService => GetIt.I.get();

  UserInfoProvider get userInfoProvider => GetIt.I.get();

  int index = 0;

  @override
  void initState() {
    super.initState();
    initTimer();
  }

  void initTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (index > 4) {
          checkAppLatestOrNot().then((value) {
            userInfoProvider.initIPC();
          });
          return;
        }
        setState(() {
          index++;
        });
      },
    );
  }

  Future<void> _loadWallets() async {
    await sl<LocalDataSource>().clearDataOnIosUnInstall();
    await walletsStore.loadWallets();

    if (walletsStore.getWallets().value.isEmpty) {
      //Loads the last used wallet.
      Navigator.of(navigatorKey.currentState!.overlay!.context).pushReplacementNamed(RouteUtil.ROUTE_ONBOARDING);
    } else {
      final repository = GetIt.I.get<Repository>();

      final loginBiometricResponse = repository.getBiometricLogin();

      if (loginBiometricResponse.isLeft()) {
        moveToHome();
        return;
      }

      if (!loginBiometricResponse.getOrElse(() => false)) {
        moveToHome();
        return;
      }

      final authenticateResponse = await repository.authenticate();

      if (!authenticateResponse.getOrElse(() => false)) {
        authenticateResponse.swap().toOption().toNullable()!.message.show();
        return;
      }
      moveToHome();
    }
  }

  void moveToHome() {
    Navigator.of(navigatorKey.currentState!.overlay!.context).pushReplacementNamed(RouteUtil.ROUTE_HOME);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSplashScreenBgColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: Image.asset(
              ImageUtil.BG_IMAGES[index],
              key: UniqueKey(),
            ),
          ),
        ),
      ),
      // body: Container(
      //   height: double.infinity,
      //   decoration: BoxDecoration(
      //     color: AppColors.kSplashScreenBgColor,
      //     image: DecorationImage(
      //       image: AssetImage(ImageUtil.SPLASH_SCREEN_BG),
      //       fit: BoxFit.fill,
      //     ),
      //   ),
      // ),
    );
  }

  Future<bool> checkAppLatestOrNot() async {
    final getAppInfoResult = await getAppInfo();

    final appVersion = "${getAppInfoResult.version}+${getAppInfoResult.buildNumber}";

    String remoteConfigVersion;
    if (Platform.isAndroid) {
      remoteConfigVersion = remoteConfigService.getAndroidAppVersion();
    } else {
      remoteConfigVersion = remoteConfigService.getIOSAppVersion();
    }

    if (appVersion == remoteConfigVersion) {
      _loadWallets();
      return true;
    }

    await walletsStore.loadWallets();

    Navigator.of(navigatorKey.currentState!.overlay!.context).pushReplacementNamed(RouteUtil.ROUTE_APP_UPDATE, arguments: remoteConfigVersion);

    return false;
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
