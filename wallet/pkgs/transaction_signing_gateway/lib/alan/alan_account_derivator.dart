import 'package:alan/alan.dart' as alan;
import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:transaction_signing_gateway/account_derivator.dart';
import 'package:transaction_signing_gateway/alan/alan_account_derivation_info.dart';
import 'package:transaction_signing_gateway/alan/alan_private_account_credentials.dart';
import 'package:transaction_signing_gateway/model/account_derivation_failure.dart';
import 'package:transaction_signing_gateway/model/account_derivation_info.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';
import 'package:uuid/uuid.dart';

class AlanAccountDerivator implements AccountDerivator {
  @override
  Future<Either<AccountDerivationFailure, PrivateAccountCredentials>> derive({
    required AccountDerivationInfo accountDerivationInfo,
  }) async {
    try {
      final alanAccountDerivationInfo = accountDerivationInfo as AlanAccountDerivationInfo;
      final account = await compute(_deriveAccountSync, alanAccountDerivationInfo);
      return right(
        AlanPrivateAccountCredentials(
          publicInfo: AccountPublicInfo(
            chainId: alanAccountDerivationInfo.chainId,
            accountId: const Uuid().v4(),
            name: alanAccountDerivationInfo.accountAlias,
            publicAddress: account.bech32Address,
          ),
          mnemonic: alanAccountDerivationInfo.mnemonic,
        ),
      );
    } catch (ex, stack) {
      logError(ex, stack);
      return left(
        InvalidMnemonicFailure(
          ex,
          stack: stack,
        ),
      );
    }
  }

  @override
  bool canDerive(AccountDerivationInfo accountDerivationInfo) => accountDerivationInfo is AlanAccountDerivationInfo;
}

alan.Wallet _deriveAccountSync(AlanAccountDerivationInfo derivationInfo) => alan.Wallet.derive(
      derivationInfo.mnemonic.split(' '),
      derivationInfo.networkInfo,
    );
