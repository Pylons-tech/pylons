import 'dart:io';

import 'package:cosmos_ui_components/cosmos_ui_components.dart';
import 'package:cosmos_utils/app_info_extractor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/pages/settings/utils/user_info_provider.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/data_stores/local_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/remote_config_service/remote_config_service.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/route_util.dart';

import '../settings/screens/general_screen/general_screen_localization_view_model.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({Key? key}) : super(key: key);

  @override
  _RoutingPageState createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  WalletsStore get walletsStore => GetIt.I.get();

  RemoteConfigService get remoteConfigService => GetIt.I.get();

  UserInfoProvider get userInfoProvider => GetIt.I.get();
  late GeneralScreenLocalizationViewModel languageViewModel;

  @override
  void initState() {
    languageViewModel = context.read<GeneralScreenLocalizationViewModel>();

    super.initState();
    checkAppLatestOrNot().then((value) {
      userInfoProvider.initIPC();
    });
  }

  Future<void> _loadWallets() async {
    await sl<LocalDataSource>().clearDataOnIosUnInstall();
    await walletsStore.loadWallets();

    if (walletsStore.getWallets().value.isEmpty) {
      // setDefaultLocale();

      Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamed(RouteUtil.ROUTE_ONBOARDING);
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
    Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamed(RouteUtil.ROUTE_HOME);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentStateSwitcher(
        isLoading: walletsStore.getAreWalletsLoading().value,
        isError: walletsStore.getLoadWalletsFailure().value != null,
        errorChild: CosmosErrorView(
          title: "something_wrong".tr(),
          message: "wallet_retrieving_err_msg".tr(),
        ),
        contentChild: const SizedBox(),
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

    await walletsStore.loadWallets();

    Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamed(RouteUtil.ROUTE_APP_UPDATE, arguments: remoteConfigVersion);

    return false;
  }
}
