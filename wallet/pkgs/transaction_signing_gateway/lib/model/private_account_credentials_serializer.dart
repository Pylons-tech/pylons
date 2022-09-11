import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';

abstract class PrivateAccountCredentialsSerializer {
  String get identifier;

  Either<CredentialsStorageFailure, PrivateAccountCredentials> fromJson(Map<String, dynamic> json);

  Either<CredentialsStorageFailure, Map<String, dynamic>> toJson(PrivateAccountCredentials credentials);
}
