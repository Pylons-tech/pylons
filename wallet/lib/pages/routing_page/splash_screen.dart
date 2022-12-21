import 'dart:async';
import 'dart:io';
import 'package:cosmos_utils/app_info_extractor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/pages/settings/utils/user_info_provider.dart';
import 'package:pylons_wallet/providers/account_provider.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/data_stores/local_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/remote_config_service/remote_config_service.dart';
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

  late AccountProvider accountProvider;

  RemoteConfigService get remoteConfigService => GetIt.I.get();

  UserInfoProvider get userInfoProvider => GetIt.I.get();

  ValueNotifier<int> getImageIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    accountProvider = context.read<AccountProvider>();

    initTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ImageUtil.BG_IMAGES.map((e) => precacheImage(e.image, context));
  }

  void initTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (getImageIndex.value == 5) {
          timer.cancel();
          checkAppLatestOrNot().then((value) {
            userInfoProvider.initIPC();
          });
          return;
        }
        getImageIndex.value++;
      },
    );
  }

  Future<void> _loadWallets() async {
    await sl<LocalDataSource>().clearDataOnIosUnInstall();

    await accountProvider.loadWallets();

    if (accountProvider.accountPublicInfo == null) {
      //Loads the last used wallet.
      Navigator.of(
        navigatorKey.currentState!.overlay!.context,
      ).pushReplacementNamed(RouteUtil.ROUTE_ONBOARDING);
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
    Navigator.of(
      navigatorKey.currentState!.overlay!.context,
    ).pushReplacementNamed(RouteUtil.ROUTE_HOME);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ImageUtil.SPLASH_SCREEN_BG,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 145.0.h,
                ),
                ValueListenableBuilder(
                  valueListenable: getImageIndex,
                  builder: (context, int value, child) {
                    return SizedBox(
                      height: 0.5.sh,
                      child: ClipRect(
                        child: AnimatedSwitcher(
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          duration: const Duration(milliseconds: 1500),
                          child: ImageUtil.BG_IMAGES[value],
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                SizedBox(
                  height: 30.0.h,
                  child: Image.asset(
                    ImageUtil.PYLONS_LOGO_DARK,
                  ),
                ),
                SizedBox(
                  height: 55.0.h,
                ),
              ],
            ),
          ),
        ),
      ),
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

    await accountProvider.loadWallets();

    Navigator.of(navigatorKey.currentState!.overlay!.context).pushReplacementNamed(
      RouteUtil.ROUTE_APP_UPDATE,
      arguments: remoteConfigVersion,
    );

    return false;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
