import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallets_store.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:transaction_signing_gateway/alan/alan_credentials_serializer.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_broadcaster.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_signer.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/mobile/mobile_key_info_storage.dart';
import 'package:transaction_signing_gateway/mobile/no_op_transaction_summary_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // Read the values from .env file
  await dotenv.load();
  _buildDependencies();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'i18n',
      fallbackLocale: const Locale('en'),
      saveLocale: false,
      useOnlyLangCode: true,
      child: PylonsApp()
  ),);
}

void _buildDependencies() {
  PylonsApp.signingGateway = TransactionSigningGateway(
    transactionSummaryUI: NoOpTransactionSummaryUI(),
    signers: [
      AlanTransactionSigner(),
    ],
    broadcasters: [
      AlanTransactionBroadcaster(),
    ],
    infoStorage: MobileKeyInfoStorage(
      serializers: [AlanCredentialsSerializer()],
    ),
  );

  PylonsApp.baseEnv = BaseEnv()
    ..setEnv(
      lcdUrl: dotenv.env['LCD_URL']!,
      grpcUrl: dotenv.env['GRPC_URL']!,
      lcdPort: dotenv.env['LCD_PORT']!,
      grpcPort: dotenv.env['GRPC_PORT']!,
      ethUrl: dotenv.env['ETH_URL']!,
      tendermintPort: dotenv.env['TENDERMINT_PORT']!,
      faucetUrl: dotenv.env['FAUCET_URL'],
      faucetPort: dotenv.env['FAUCET_PORT'],
      wsUrl: dotenv.env['WS_URL']!
    );
  PylonsApp.walletsStore = WalletsStore(PylonsApp.signingGateway, PylonsApp.baseEnv);
}
