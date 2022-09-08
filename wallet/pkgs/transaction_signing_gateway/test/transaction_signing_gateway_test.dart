import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_signing_gateway/model/account_lookup_key.dart';
import 'package:transaction_signing_gateway/model/transaction_signing_failure.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

import 'mocks/key_info_storage_mock.dart';
import 'mocks/private_account_credentials_mock.dart';
import 'mocks/transaction_summary_ui_mock.dart';

void main() {
  group('Mock TransactionSummary', () {
    late TransactionSummaryUIMock summaryUI;
    late KeyInfoStorageMock infoStorage;
    late TransactionSigningGateway signingGateway;
    const chainId = 'atom';
    const accountId = '123walletId';
    const publicAddress = 'cosmos1wze8mn5nsgl9qrgazq6a92fvh7m5e6psjcx2du';
    const name = 'name';
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

    test('declining ui returns failure', () async {
      // GIVEN
      when(() => summaryUI.showTransactionSummaryUI(transaction: any(named: 'transaction')))
          .thenAnswer((_) async => Future.value(left(const UserDeclinedTransactionSignerFailure())));
      // WHEN
      final result = await signingGateway.signTransaction(
        transaction: UnsignedTransaction(),
        accountLookupKey: const AccountLookupKey(
          chainId: chainId,
          password: 'password',
          accountId: accountId,
        ),
      );
      // THEN
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => r), isA<UserDeclinedTransactionSignerFailure>());
      verifyNever(() => infoStorage.getPrivateCredentials(any()));
    });

    test('failing to retrieve key returns failure', () async {
      // GIVEN
      when(() => summaryUI.showTransactionSummaryUI(transaction: any(named: 'transaction')))
          .thenAnswer((_) async => right(unit));
      when(() => infoStorage.getPrivateCredentials(any())) //
          .thenAnswer((_) async => left(const CredentialsStorageFailure('fail')));
      // WHEN
      final result = await signingGateway.signTransaction(
        transaction: UnsignedTransaction(),
        accountLookupKey: const AccountLookupKey(
          chainId: chainId,
          password: 'password',
          accountId: accountId,
        ),
      );
      // THEN
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => r), isA<TransactionSigningFailure>());
      verify(() => summaryUI.showTransactionSummaryUI(transaction: any(named: 'transaction')));
    });

    test('missing proper signer returns failure', () async {
      // GIVEN
      when(() => summaryUI.showTransactionSummaryUI(transaction: any(named: 'transaction')))
          .thenAnswer((_) async => right(unit));
      when(() => infoStorage.getPrivateCredentials(any())).thenAnswer((_) async => right(privateCredsStub));
      // WHEN
      final result = await signingGateway.signTransaction(
        transaction: UnsignedTransaction(),
        accountLookupKey: const AccountLookupKey(
          chainId: chainId,
          password: 'password',
          accountId: accountId,
        ),
      );
      // THEN
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => r), isA<TransactionSignerNotFoundFailure>());
      verify(() => summaryUI.showTransactionSummaryUI(transaction: any(named: 'transaction')));
      verify(() => infoStorage.getPrivateCredentials(any()));
    });

    setUp(() {
      summaryUI = TransactionSummaryUIMock();
      infoStorage = KeyInfoStorageMock();
      registerFallbackValue(const UnsignedAlanTransaction(messages: []));
      registerFallbackValue(
        const AccountLookupKey(
          chainId: chainId,
          accountId: accountId,
          password: 'password',
        ),
      );
      signingGateway = TransactionSigningGateway(
        transactionSummaryUI: summaryUI,
        signers: [],
        broadcasters: [],
        infoStorage: infoStorage,
        derivators: [],
      );
    });
  });
}
