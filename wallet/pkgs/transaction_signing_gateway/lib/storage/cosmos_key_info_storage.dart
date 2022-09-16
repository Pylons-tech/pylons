import 'dart:convert';

import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:transaction_signing_gateway/encrypt/aes_cipher.dart';
import 'package:transaction_signing_gateway/encrypt/cipher.dart';
import 'package:transaction_signing_gateway/model/account_lookup_key.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import 'package:transaction_signing_gateway/model/account_public_info_serializer.dart';
import 'package:transaction_signing_gateway/model/clear_credentials_failure.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials_serializer.dart';
import 'package:transaction_signing_gateway/model/transaction_signing_failure.dart';
import 'package:transaction_signing_gateway/storage/key_info_storage.dart';

class CosmosKeyInfoStorage implements KeyInfoStorage {
  CosmosKeyInfoStorage({
    required this.serializers,
    required SecureDataStore secureDataStore,
    required PlainDataStore plainDataStore,
    Cipher? cipher,
  })  : _secureDataStore = secureDataStore,
        _plainDataStore = plainDataStore,
        _cipher = cipher ?? AESCipher();

  static const _publicKeySuffix = ':public';
  final List<PrivateAccountCredentialsSerializer> serializers;
  final SecureDataStore _secureDataStore;
  final PlainDataStore _plainDataStore;

  final Cipher _cipher;

  @override
  Future<Either<CredentialsStorageFailure, PrivateAccountCredentials>> getPrivateCredentials(
    AccountLookupKey accountLookupKey,
  ) =>
      _secureDataStore
          .readSecureText(
            key: _credentialsKey(
              chainId: accountLookupKey.chainId,
              accountId: accountLookupKey.accountId,
            ),
          )
          .zipWith(
            _findDeserializer(
              _serializerIdKey(
                chainId: accountLookupKey.chainId,
                accountId: accountLookupKey.accountId,
              ),
            ),
          )
          .flatMap<PrivateAccountCredentials>(
        (tuple) async {
          final data = tuple.value1;
          final serializer = tuple.value2;
          if (data == null) {
            return left(CredentialsStorageFailure('Could not find credentials for $accountLookupKey'));
          }
          if (serializer == null) {
            return left(CredentialsStorageFailure('Could not find proper deserializer for $accountLookupKey'));
          }

          try {
            final decrypted = _cipher.decrypt(password: accountLookupKey.password, encryptedData: data);
            final json = await compute(jsonDecode, decrypted) as Map<String, dynamic>;
            return serializer.fromJson(json);
          } catch (error, stack) {
            logError(error, stack);
            return left(
              CredentialsStorageFailure(
                'invalid password',
                cause: error,
                stack: stack,
              ),
            );
          }
        },
      ).doOn(
        fail: logError,
      );

  String _credentialsKey({required String chainId, required String accountId}) => '$chainId:$accountId';

  String _publicInfoKey({required String chainId, required String accountId}) => '$chainId:$accountId$_publicKeySuffix';

  bool _isPublicInfoKey(String key) => key.endsWith(_publicKeySuffix);

  String _serializerIdKey({required String chainId, required String accountId}) => '$chainId:$accountId:serializer';

  @override
  Future<Either<CredentialsStorageFailure, Unit>> savePrivateCredentials({
    required PrivateAccountCredentials accountCredentials,
    required String password,
  }) async {
    final serializer = _findSerializer(accountCredentials);
    if (serializer == null) {
      return left(
        CredentialsStorageFailure('Could not find proper serializer for ${accountCredentials.runtimeType}'),
      );
    }
    final credsKey = _credentialsKey(
      chainId: accountCredentials.publicInfo.chainId,
      accountId: accountCredentials.publicInfo.accountId,
    );
    final serializerKey = _serializerIdKey(
      chainId: accountCredentials.publicInfo.chainId,
      accountId: accountCredentials.publicInfo.accountId,
    );
    final publicInfoKey = _publicInfoKey(
      chainId: accountCredentials.publicInfo.chainId,
      accountId: accountCredentials.publicInfo.accountId,
    );
    final publicInfoJson = await compute(jsonEncode, AccountPublicInfoSerializer.toMap(accountCredentials.publicInfo));
    return Future.value(serializer.toJson(accountCredentials))
        .flatMap((jsonMap) async => right(await compute(jsonEncode, jsonMap)))
        .flatMap((jsonString) async {
      final encrypted = _cipher.encrypt(password: password, data: jsonString);
      return _secureDataStore.saveSecureText(key: credsKey, value: encrypted);
    }).flatMap((_) {
      return _plainDataStore.savePlainText(key: serializerKey, value: accountCredentials.serializerIdentifier);
    }).flatMap((_) {
      return _plainDataStore.savePlainText(key: publicInfoKey, value: publicInfoJson);
    }).map((_) {
      return right(unit);
    });
  }

  @override
  Future<Either<CredentialsStorageFailure, Unit>> deleteAccountCredentials({
    required AccountPublicInfo publicInfo,
  }) async {
    final credsKey = _credentialsKey(
      chainId: publicInfo.chainId,
      accountId: publicInfo.accountId,
    );
    final serializerKey = _serializerIdKey(
      chainId: publicInfo.chainId,
      accountId: publicInfo.accountId,
    );
    final publicInfoKey = _publicInfoKey(
      chainId: publicInfo.chainId,
      accountId: publicInfo.accountId,
    );

    return _secureDataStore.saveSecureText(key: credsKey, value: null).flatMap((_) {
      return _plainDataStore.savePlainText(key: serializerKey, value: null);
    }).flatMap((_) {
      return _plainDataStore.savePlainText(key: publicInfoKey, value: null);
    }).map((_) {
      return right(unit);
    });
  }

  @override
  Future<Either<CredentialsStorageFailure, List<AccountPublicInfo>>> getAccountsList() async =>
      _plainDataStore.readAllPlainText().flatMap(
        (storageMap) async {
          try {
            final infos = storageMap.keys //
                .where(_isPublicInfoKey)
                .map((key) {
                  return jsonDecode(storageMap[key] ?? '') as Map<String, dynamic>;
                })
                .map(AccountPublicInfoSerializer.fromMap)
                .toList();
            return right(infos);
          } catch (error, stack) {
            logError(error, stack);
            return left(
              CredentialsStorageFailure(
                '$error',
                cause: error,
                stack: stack,
              ),
            );
          }
        },
      );

  Future<Either<CredentialsStorageFailure, PrivateAccountCredentialsSerializer?>> _findDeserializer(
    String serializerIdKey,
  ) =>
      _plainDataStore.readPlainText(key: serializerIdKey).flatMap(
        (identifier) async {
          if (identifier == null) {
            return right(null);
          }
          return right(
            serializers.cast<PrivateAccountCredentialsSerializer?>().firstWhere(
                  (element) => element?.identifier == identifier,
                  orElse: () => null,
                ),
          );
        },
      );

  PrivateAccountCredentialsSerializer? _findSerializer(PrivateAccountCredentials creds) =>
      serializers.cast<PrivateAccountCredentialsSerializer?>().firstWhere(
            (element) => element?.identifier == creds.serializerIdentifier,
            orElse: () => null,
          );

  @override
  Future<Either<TransactionSigningFailure, bool>> verifyLookupKey(AccountLookupKey accountLookupKey) async {
    final privateCreds = await getPrivateCredentials(accountLookupKey);
    return right(privateCreds.isRight());
  }

  @override
  Future<Either<CredentialsStorageFailure, Unit>> updatePublicAccountInfo({required AccountPublicInfo info}) async {
    try {
      final publicInfoKey = _publicInfoKey(
        chainId: info.chainId,
        accountId: info.accountId,
      );

      return _plainDataStore.readPlainText(key: publicInfoKey).flatMap((accountInfo) async {
        if (accountInfo == null) {
          return left(const CredentialsStorageFailure('Account not found'));
        }

        final publicInfoJson = await compute(jsonEncode, AccountPublicInfoSerializer.toMap(info));
        return _plainDataStore.savePlainText(key: publicInfoKey, value: publicInfoJson);
      });
    } catch (error, stack) {
      logError(error, stack);
      return left(
        CredentialsStorageFailure(
          '$error',
          cause: error,
          stack: stack,
        ),
      );
    }
  }

  @override
  Future<Either<ClearCredentialsFailure, Unit>> clearCredentials() async {
    return _secureDataStore
        .clearAllData() //
        .zipWith(_plainDataStore.clearAllData())
        .mapError(ClearCredentialsFailure.unknown)
        .flatMap((result) async {
      if (!result.value1 || !result.value2) {
        return left(
          ClearCredentialsFailure.unknown(
            'data clearing failed: secured store failed: ${result.value1} & plain store failed: ${result.value2}',
          ),
        );
      }
      return right(unit);
    });
  }
}
