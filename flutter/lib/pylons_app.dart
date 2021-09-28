import 'package:flutter/material.dart';
import 'package:pylons_wallet/pages/routing_page.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
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
      title: 'Pylons Wallet',
      theme: PylonsAppTheme.buildAppTheme(),
      home: const RoutingPage(),
    );
  }
}
