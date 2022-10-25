import 'package:cosmos_utils/credentials_storage_failure.dart';
import 'package:dartz/dartz.dart';

abstract class PlainDataStore {
  Future<Either<CredentialsStorageFailure, Unit>> savePlainText({
    required String key,
    required String? value,
  });

  Future<Either<CredentialsStorageFailure, String?>> readPlainText({
    required String key,
  });

  Future<Either<CredentialsStorageFailure, Map<String, String?>>> readAllPlainText();

  Future<Either<CredentialsStorageFailure, bool>> clearAllData();
}

abstract class SecureDataStore {
  Future<Either<CredentialsStorageFailure, Unit>> saveSecureText({
    required String key,
    required String? value,
  });

  Future<Either<CredentialsStorageFailure, String?>> readSecureText({
    required String key,
  });

  Future<Either<CredentialsStorageFailure, bool>> clearAllData();
}
