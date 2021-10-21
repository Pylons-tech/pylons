import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/ipc/ipc_engine.dart';
import 'package:pylons_wallet/pages/routing_page.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/stores/wallets_store_imp.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/model/wallet_public_info.dart';


GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class PylonsApp extends StatefulWidget {
  static late TransactionSigningGateway signingGateway;

  static late String password;
  static late WalletPublicInfo currentWallet;

  @override
  State<PylonsApp> createState() => _PylonsAppState();
}

class _PylonsAppState extends State<PylonsApp> {
  IPCEngine ipcEngine = IPCEngine();

  @override
  void initState() {
    super.initState();

    ipcEngine.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: "app_title".tr(),
      theme: PylonsAppTheme().buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const RoutingPage(),
      },
    );
  }

  @override
  void dispose() {
    ipcEngine.dispose();
    super.dispose();
  }
}
