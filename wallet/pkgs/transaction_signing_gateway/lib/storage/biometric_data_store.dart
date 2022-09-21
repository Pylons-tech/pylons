import 'dart:convert';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

@Deprecated('Use "cosmos_auth" package instead')
class BiometricDataStore implements SecureDataStore {
  @Deprecated('Use "cosmos_auth" package instead')
  BiometricDataStore({
    this.promptInfo = PromptInfo.defaultValues,
    this.storageFileName = 'cosmos_account_creds',
    StorageFileInitOptions? storageFileInitOptions,
  }) : _storageFileInitOptions = storageFileInitOptions ??
            StorageFileInitOptions(
              authenticationValidityDurationSeconds:
                  1, // so that consecutive writes after reads won't ask for auth twice.
            );

  final PromptInfo promptInfo;
  final String storageFileName;
  final StorageFileInitOptions _storageFileInitOptions;

  @override
  Future<Either<CredentialsStorageFailure, String?>> readSecureText({
    required String key,
  }) async =>
      _readMap().flatMap(
        (keysMap) async {
          return right(keysMap[key]);
        },
      );

  @override
  Future<Either<CredentialsStorageFailure, Unit>> saveSecureText({
    required String key,
    required String? value,
  }) async =>
      _readMap().flatMap(
        (map) async {
          return _writeMap({
            ...map,
            key: value,
          });
        },
      );

  Future<Either<CredentialsStorageFailure, Map<String, String?>>> _readMap() async {
    return _getStorageFile() //
        .flatMap((storageFile) async {
      final fileRead = await storageFile.read();
      return right(fileRead ?? '');
    }).flatMap((storageRead) async {
      return right(await compute(_decodeMap, storageRead));
    }).catchError((ex, stack) {
      logError(ex, stack);
      return Future.value(
        left<CredentialsStorageFailure, Map<String, String?>>(
          CredentialsStorageFailure(
            'Error while reading biometric storage data',
            cause: ex,
            stack: stack,
          ),
        ),
      );
    });
  }

  Future<Either<CredentialsStorageFailure, Unit>> _writeMap(
    Map<String, String?> map,
  ) async {
    try {
      final mapString = await compute(_encodeMap, map);
      final result = await _getStorageFile() //
          .flatMap((file) async {
        return right(await file.write(mapString));
      }).flatMap((_) async {
        return right(unit);
      }).catchError(
        (ex, stack) => Future.value(
          left<CredentialsStorageFailure, Unit>(
            CredentialsStorageFailure(
              'Error while writing data to Biometric storage',
              cause: ex,
              stack: stack,
            ),
          ),
        ),
      );
      return result;
    } catch (ex, stack) {
      logError(ex, stack);
      return left(
        CredentialsStorageFailure(
          'Could not write map to secure storage',
          cause: ex,
          stack: stack,
        ),
      );
    }
  }

  Future<Either<CredentialsStorageFailure, BiometricStorageFile>> _getStorageFile() async {
    final biometricStorage = BiometricStorage();
    final canAuthenticate = await biometricStorage.canAuthenticate();
    switch (canAuthenticate) {
      case CanAuthenticateResponse.success:
        final storageFile = await biometricStorage.getStorage(
          storageFileName,
          options: _storageFileInitOptions,
          promptInfo: promptInfo,
        );
        return right(storageFile);
      case CanAuthenticateResponse.errorHwUnavailable:
        return left(BiometricCredentialsStorageFailure.unavailable());
      case CanAuthenticateResponse.errorNoBiometricEnrolled:
        return left(BiometricCredentialsStorageFailure.noBiometricEnrolled());
      case CanAuthenticateResponse.errorNoHardware:
        return left(BiometricCredentialsStorageFailure.noHardware());
      case CanAuthenticateResponse.statusUnknown:
        return left(BiometricCredentialsStorageFailure.unknown());
      case CanAuthenticateResponse.unsupported:
        return left(BiometricCredentialsStorageFailure.unsupported());
    }
  }

  @override
  Future<Either<CredentialsStorageFailure, bool>> clearAllData() async {
    try {
      final biometricStorage = BiometricStorage();
      final storageFile = await biometricStorage.getStorage(
        storageFileName,
        options: _storageFileInitOptions,
        promptInfo: promptInfo,
      );
      await storageFile.delete();
      return right(true);
    } catch (ex, stack) {
      logError(ex, stack);
      return left(
        CredentialsStorageFailure(
          'Error while clearing data in Biometric storage',
          cause: ex,
          stack: stack,
        ),
      );
    }
  }
}

Map<String, String?> _decodeMap(String json) => (json.trim().isEmpty
        ? //
        <String, dynamic>{}
        : jsonDecode(json) as Map<String, dynamic>? ?? <String, dynamic>{})
    .cast();

String _encodeMap(Map<String, String?> map) => jsonEncode(map);

enum BiometricCredentialsFailureReason {
  unsupported,
  unavailable,
  noBiometricEnrolled,
  noHardware,
  unknown,
}

class BiometricCredentialsStorageFailure extends CredentialsStorageFailure {
  BiometricCredentialsStorageFailure.unsupported()
      : reason = BiometricCredentialsFailureReason.unsupported,
        super('Biometric authentication is unsupported');

  BiometricCredentialsStorageFailure.unavailable()
      : reason = BiometricCredentialsFailureReason.unavailable,
        super('Biometric authentication is not available');

  BiometricCredentialsStorageFailure.noBiometricEnrolled()
      : reason = BiometricCredentialsFailureReason.noBiometricEnrolled,
        super('Biometric authentication is not enrolled');

  BiometricCredentialsStorageFailure.noHardware()
      : reason = BiometricCredentialsFailureReason.noHardware,
        super('Device has no hardware for biometric authentication');

  BiometricCredentialsStorageFailure.unknown([String? message])
      : reason = BiometricCredentialsFailureReason.unknown,
        super(message ?? 'Biometric authentication is unsupported');

  final BiometricCredentialsFailureReason reason;

  @override
  String toString() {
    return 'BiometricCredentialsStorageFailure{reason: $reason, message: $message}';
  }
}
