import 'package:alan/alan.dart' as alan;
import 'package:equatable/equatable.dart';
import 'package:transaction_signing_gateway/alan/alan_credentials_serializer.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';

class AlanPrivateAccountCredentials extends Equatable implements PrivateAccountCredentials {
  const AlanPrivateAccountCredentials({
    required this.mnemonic,
    required this.publicInfo,
  });

  @override
  final String mnemonic;

  @override
  final AccountPublicInfo publicInfo;

  alan.Wallet alanAccount(alan.NetworkInfo networkInfo) => alan.Wallet.derive(
        mnemonic.split(' '),
        networkInfo,
      );

  @override
  String get serializerIdentifier => AlanCredentialsSerializer.id;

  @override
  List<Object?> get props => [
        publicInfo,
        mnemonic,
      ];

  AlanPrivateAccountCredentials copyWith({
    String? mnemonic,
    AccountPublicInfo? publicInfo,
  }) {
    return AlanPrivateAccountCredentials(
      mnemonic: mnemonic ?? this.mnemonic,
      publicInfo: publicInfo ?? this.publicInfo,
    );
  }
}
