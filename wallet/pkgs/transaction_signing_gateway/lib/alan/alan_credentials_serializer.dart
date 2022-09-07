import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:transaction_signing_gateway/alan/alan_private_account_credentials.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials_serializer.dart';

class AlanCredentialsSerializer implements PrivateAccountCredentialsSerializer {
  static const id = 'AlanCredentialsSerializer';

  static const _chainIdKey = 'chain_id';
  static const _mnemonicKey = 'mnemonic';
  static const _accountIdKey = 'accountId';

  static const _nameKey = 'name';
  static const _publicAddressKey = 'publicAddress';

  @override
  Either<CredentialsStorageFailure, PrivateAccountCredentials> fromJson(Map<String, dynamic> json) {
    try {
      return right(
        AlanPrivateAccountCredentials(
          mnemonic: json[_mnemonicKey] as String? ?? '',
          publicInfo: AccountPublicInfo(
            name: json[_nameKey] as String? ?? '',
            publicAddress: json[_publicAddressKey] as String? ?? '',
            accountId: json[_accountIdKey] as String? ?? '',
            chainId: json[_chainIdKey] as String? ?? '',
          ),
        ),
      );
    } catch (error, stack) {
      logError(error, stack);
      return left(
        CredentialsStorageFailure(
          'Could not parse account credentials',
          cause: error,
          stack: stack,
        ),
      );
    }
  }

  @override
  String get identifier => id;

  @override
  Either<CredentialsStorageFailure, Map<String, dynamic>> toJson(PrivateAccountCredentials credentials) {
    if (credentials is! AlanPrivateAccountCredentials) {
      return left(
        CredentialsStorageFailure(
          'Passed credentials are not of type $AlanPrivateAccountCredentials. actual: $credentials',
        ),
      );
    }
    return right({
      _chainIdKey: credentials.publicInfo.chainId,
      _accountIdKey: credentials.publicInfo.accountId,
      _publicAddressKey: credentials.publicInfo.publicAddress,
      _nameKey: credentials.publicInfo.name,
      _mnemonicKey: credentials.mnemonic,
    });
  }
}
