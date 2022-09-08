import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:dartz/dartz.dart';

class TestMemoryStore implements PlainDataStore, SecureDataStore {
  final Map<String, String?> _values = {};

  @override
  Future<Either<CredentialsStorageFailure, bool>> clearAllData() async {
    _values.clear();
    return right(true);
  }

  @override
  Future<Either<CredentialsStorageFailure, Map<String, String?>>> readAllPlainText() async => right({..._values});

  @override
  Future<Either<CredentialsStorageFailure, String?>> readPlainText({
    required String key,
  }) async =>
      right(_values[key]);

  @override
  Future<Either<CredentialsStorageFailure, Unit>> savePlainText({
    required String key,
    required String? value,
  }) async {
    _values[key] = value;
    return right(unit);
  }

  @override
  Future<Either<CredentialsStorageFailure, String?>> readSecureText({
    required String key,
  }) =>
      readPlainText(key: key);

  @override
  Future<Either<CredentialsStorageFailure, Unit>> saveSecureText({
    required String key,
    required String? value,
  }) =>
      savePlainText(key: key, value: value);
}
