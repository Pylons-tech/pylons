import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ru', ''),
        ],
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },
      theme: PylonsAppTheme.buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const RoutingPage(),
      },
    );
  }
}
