import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_signing_gateway/alan/alan_credentials_serializer.dart';
import 'package:transaction_signing_gateway/alan/alan_private_account_credentials.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';

void main() {
  group('Alan Serializer tests', () {
    final serializer = AlanCredentialsSerializer();
    const credentials = AlanPrivateAccountCredentials(
      mnemonic: 'mnemonic',
      publicInfo: AccountPublicInfo(
        chainId: 'chainId',
        accountId: 'accountId',
        name: 'name',
        publicAddress: 'cosmos1ec4v57s7weuwatd36dgpjh8hj4gnj2cuut9sav',
      ),
    );

    test('serializes and deserializes correctly', () {
      final jsonResult = serializer.toJson(credentials);
      expect(jsonResult.isRight(), true);
      final credentialsResult = jsonResult.flatMap(serializer.fromJson);
      expect(credentialsResult.isRight(), true);
      final alanCredsResult = credentialsResult.getOrElse(() => throw '') as AlanPrivateAccountCredentials;
      expect(alanCredsResult, credentials);
    });
  });
}
