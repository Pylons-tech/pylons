import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

import 'common.dart';

class WalletCreationModel {
  final AlanPrivateAccountCredentials creds;
  final Address creatorAddress;

  WalletCreationModel({
    required this.creds,
    required this.creatorAddress,
  });
}
