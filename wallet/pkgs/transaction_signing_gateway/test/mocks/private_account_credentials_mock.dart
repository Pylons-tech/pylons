import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials_serializer.dart';

class PrivateAccountCredentialsMock extends Equatable implements PrivateAccountCredentials {
  const PrivateAccountCredentialsMock({
    required this.mnemonic,
    required this.publicInfo,
  });

  @override
  final String mnemonic;

  @override
  final AccountPublicInfo publicInfo;

  @override
  String get serializerIdentifier => TestPrivateCredentialsSerializer.sIdentifier;

  @override
  List<Object?> get props => [
        mnemonic,
        publicInfo,
        serializerIdentifier,
      ];
}

class TestPrivateCredentialsSerializer implements PrivateAccountCredentialsSerializer {
  static const String sIdentifier = 'TestPrivateCredentialsSerializer';

  @override
  Either<CredentialsStorageFailure, PrivateAccountCredentials> fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      return right(
        PrivateAccountCredentialsMock(
          publicInfo: AccountPublicInfo(
            chainId: json['chainId'] as String,
            accountId: json['walletId'] as String,
            name: json['name'] as String,
            publicAddress: json['publicAddress'] as String,
          ),
          mnemonic: json['mnemonic'] as String,
        ),
      );
    } catch (e) {
      return left(CredentialsStorageFailure('could not parse json:\n$json'));
    }
  }

  @override
  String get identifier => sIdentifier;

  @override
  Either<CredentialsStorageFailure, Map<String, dynamic>> toJson(
    PrivateAccountCredentials credentials,
  ) =>
      right({
        'chainId': credentials.publicInfo.chainId,
        'walletId': credentials.publicInfo.accountId,
        'mnemonic': credentials.mnemonic,
        'name': credentials.publicInfo.name,
        'publicAddress': credentials.publicInfo.publicAddress
      });
}
