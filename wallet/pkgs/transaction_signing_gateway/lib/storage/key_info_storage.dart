import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:transaction_signing_gateway/model/account_lookup_key.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import 'package:transaction_signing_gateway/model/clear_credentials_failure.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';
import 'package:transaction_signing_gateway/model/transaction_signing_failure.dart';

abstract class KeyInfoStorage {
  Future<Either<ClearCredentialsFailure, Unit>> clearCredentials();

  Future<Either<CredentialsStorageFailure, PrivateAccountCredentials>> getPrivateCredentials(
    AccountLookupKey accountLookupKey,
  );

  Future<Either<CredentialsStorageFailure, Unit>> savePrivateCredentials({
    required PrivateAccountCredentials accountCredentials,
    required String password,
  });

  Future<Either<CredentialsStorageFailure, Unit>> deleteAccountCredentials({required AccountPublicInfo publicInfo});

  Future<Either<CredentialsStorageFailure, Unit>> updatePublicAccountInfo({
    required AccountPublicInfo info,
  });

  Future<Either<CredentialsStorageFailure, List<AccountPublicInfo>>> getAccountsList();

  Future<Either<TransactionSigningFailure, bool>> verifyLookupKey(AccountLookupKey accountLookupKey);
}
