import 'package:flutter/material.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallets_store.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:transaction_signing_gateway/alan/alan_credentials_serializer.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_broadcaster.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_signer.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/mobile/mobile_key_info_storage.dart';
import 'package:transaction_signing_gateway/mobile/no_op_transaction_summary_ui.dart';

void main() {
  _buildDependencies();
  runApp(PylonsApp());
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
      lcdUrl: lcdUrl,
      grpcUrl: grpcPort,
      lcdPort: lcdPort,
      grpcPort: grpcPort,
      ethUrl: ethUrl,
      tendermintPort: tendermintPort,
      faucetPort: faucetPort,
      wsUrl: wsUrl
    );
  PylonsApp.walletsStore = WalletsStore(PylonsApp.signingGateway, PylonsApp.baseEnv);
}
