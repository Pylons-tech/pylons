import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_signing_gateway/model/account_lookup_key.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

import 'mocks/private_account_credentials_mock.dart';
import 'mocks/test_memory_store.dart';

void main() {
  group('MobileKeyInfoStorage', () {
    const chainId = 'atom';
    const accountId = '123walletId';
    const password = 'coolPassword123';
    const name = 'name';
    const publicAddress = 'cosmos1wze8mn5nsgl9qrgazq6a92fvh7m5e6psjcx2du';
    const publicAddress2 = 'cosmos124maqmcqv8tquy764ktz7cu0gxnzfw54k9cmz5';
    const mnemonic =
        'fruit talent run shallow police ripple wheat original cabbage vendor tilt income gasp meat acid annual armed system target great oxygen artist net elegant';

    const privateCredsStub = PrivateAccountCredentialsMock(
      publicInfo: AccountPublicInfo(
        name: name,
        publicAddress: publicAddress,
        accountId: accountId,
        chainId: chainId,
      ),
      mnemonic: mnemonic,
    );
    const privateCredsStub2 = PrivateAccountCredentialsMock(
      publicInfo: AccountPublicInfo(
        name: '$name 2',
        publicAddress: publicAddress2,
        accountId: '${accountId}2',
        chainId: '${chainId}2',
      ),
      mnemonic: mnemonic,
    );
    final storage = CosmosKeyInfoStorage(
      serializers: [TestPrivateCredentialsSerializer()],
      secureDataStore: TestMemoryStore(),
      plainDataStore: TestMemoryStore(),
    );
    //
    test('save and retrieve creds', () async {
      final saveResult = await storage.savePrivateCredentials(accountCredentials: privateCredsStub, password: password);
      expect(saveResult.isRight(), true, reason: '$saveResult');

      final readResult = await storage.getPrivateCredentials(
        const AccountLookupKey(
          chainId: chainId,
          accountId: accountId,
          password: password,
        ),
      );
      expect(readResult.isRight(), true, reason: '$readResult');
      expect(readResult.getOrElse(() => throw AssertionError()), privateCredsStub);
    });

    //
    test('retrieve public infos', () async {
      await storage.savePrivateCredentials(accountCredentials: privateCredsStub, password: password);
      await storage.savePrivateCredentials(accountCredentials: privateCredsStub2, password: password);

      final readResult = await storage.getAccountsList();
      expect(readResult.isRight(), true, reason: '$readResult');
      final list = readResult.getOrElse(() => throw AssertionError());
      expect(list[0], privateCredsStub.publicInfo);
      expect(list[1], privateCredsStub2.publicInfo);
    });
    //
  });
}
