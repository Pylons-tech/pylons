import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/pages/routing_page.dart';
import 'package:pylons_wallet/stores/wallets_store.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/model/wallet_public_info.dart';

class PylonsApp extends StatelessWidget {
  static late TransactionSigningGateway signingGateway;
  static late WalletsStore walletsStore;
  static late BaseEnv baseEnv;
  static late String password;
  static late WalletPublicInfo currentWallet;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: "app_title".tr(),
      theme: PylonsAppTheme.buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const RoutingPage(),
      },
    );
  }
}
