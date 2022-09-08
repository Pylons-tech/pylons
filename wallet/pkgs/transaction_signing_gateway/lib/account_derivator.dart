import 'package:dartz/dartz.dart';
import 'package:transaction_signing_gateway/model/account_derivation_failure.dart';
import 'package:transaction_signing_gateway/model/account_derivation_info.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';

abstract class AccountDerivator {
  Future<Either<AccountDerivationFailure, PrivateAccountCredentials>> derive({
    required AccountDerivationInfo accountDerivationInfo,
  });

  bool canDerive(AccountDerivationInfo accountDerivationInfo);
}

class NotFoundDerivator implements AccountDerivator {
  @override
  bool canDerive(AccountDerivationInfo accountDerivationInfo) => true;

  @override
  Future<Either<AccountDerivationFailure, PrivateAccountCredentials>> derive({
    required AccountDerivationInfo accountDerivationInfo,
  }) async =>
      left(const DerivatorNotFoundFailure());
}
