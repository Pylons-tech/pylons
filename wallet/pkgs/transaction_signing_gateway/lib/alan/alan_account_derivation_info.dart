import 'package:alan/wallet/network_info.dart';
import 'package:transaction_signing_gateway/model/account_derivation_info.dart';

class AlanAccountDerivationInfo implements AccountDerivationInfo {
  AlanAccountDerivationInfo({
    required this.chainId,
    required this.accountAlias,
    required this.networkInfo,
    required this.mnemonic,
  });

  final String mnemonic;
  final String chainId;
  final String accountAlias;

  final NetworkInfo networkInfo;
}
