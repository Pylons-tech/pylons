import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageDataStore implements SecureDataStore {
  FlutterSecureStorageDataStore({
    FlutterSecureStorage? storage,
  }) : _store = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _store;
  static const iosOptions = IOSOptions(accessibility: IOSAccessibility.passcode);
  static const androidOptions = AndroidOptions(encryptedSharedPreferences: true);

  @override
  Future<Either<CredentialsStorageFailure, String?>> readSecureText({required String key}) async {
    try {
      return right(
        await _store.read(
          key: key,
          iOptions: iosOptions,
          aOptions: androidOptions,
        ),
      );
    } catch (ex, stack) {
      logError(ex, stack);
      return left(
        CredentialsStorageFailure(
          "Could not retrieve secure text for key '$key'",
          cause: ex,
          stack: stack,
        ),
      );
    }
  }

  @override
  Future<Either<CredentialsStorageFailure, Unit>> saveSecureText({required String key, required String? value}) async {
    try {
      await _store.write(
        key: key,
        value: value,
        iOptions: const IOSOptions(accessibility: IOSAccessibility.passcode),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );
      return right(unit);
    } catch (ex, stack) {
      logError(ex, stack);
      return left(
        CredentialsStorageFailure(
          "Could not write secure text for key '$key'",
          cause: ex,
          stack: stack,
        ),
      );
    }
  }

  @override
  Future<Either<CredentialsStorageFailure, bool>> clearAllData() async {
    try {
      await _store.deleteAll(
        iOptions: iosOptions,
        aOptions: androidOptions,
      );
      return right(true);
    } catch (ex, stack) {
      logError(ex, stack);
      return left(
        CredentialsStorageFailure(
          "Could not delete secure data'",
          cause: ex,
          stack: stack,
        ),
      );
    }
  }
}
