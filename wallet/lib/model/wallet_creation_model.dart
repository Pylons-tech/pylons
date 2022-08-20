import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

class WalletCreationModel {
  final AlanPrivateAccountCredentials creds;

  final String creatorAddress;
  final String userName;

  WalletCreationModel(
      {required this.creds,
      required this.creatorAddress,
      required this.userName});
}
