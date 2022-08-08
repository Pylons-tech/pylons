import 'package:cosmos_utils/credentials_storage_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:transaction_signing_gateway/model/account_lookup_key.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

void main() {
  // group("Mock TransactionSummary", () {
  //   late NoOpTransactionSummaryUI summaryUI;
  //   late KeyInfoStorageMock infoStorage;
  //   late TransactionSigningGateway signingGateway;
  //   final signer = AlanTransactionSigner(
  //     NetworkInfo.fromSingleHost(
  //       bech32Hrp: 'pylo',
  //       host: 'localhost',
  //     ),
  //   );
  //   final derivator = AlanWalletDerivator();
  //   const chainId = "atom";
  //   const walletId = "123walletId";
  //   const publicAddress = "pylo182p8g4xe878xa4j6uhv4d0266hkqu8sadgy74x";
  //   const name = "name";
  //   const mnemonic =
  //       "gadget sweet hard become view cargo unhappy horn defy chimney nuclear trap subway icon hard regret siren gadget squeeze couple bring rate fortune slim";
  //   const privateCredsStub = AlanPrivateWalletCredentials(
  //     mnemonic: mnemonic,
  //     publicInfo: WalletPublicInfo(
  //       name: name,
  //       publicAddress: publicAddress,
  //       walletId: walletId,
  //       chainId: chainId,
  //     ),
  //   );
  //
  //   test("declining ui returns failure", () async {
  //     when(infoStorage.getPrivateCredentials(any)).thenAnswer((_) async => right(privateCredsStub));
  //
  //     final message = bank.MsgSend.create()
  //       ..fromAddress = privateCredsStub.publicInfo.publicAddress
  //       ..toAddress = '1up05fqctdwfc9dlgwsyfn5385r7hmfh0rwydgq';
  //     message.amount.add(
  //       Coin.create()
  //         ..denom = 'token'
  //         ..amount = '100',
  //     );
  //
  //     final result = await signingGateway.signTransaction(
  //       transaction: UnsignedAlanTransaction(messages: [message]),
  //       walletLookupKey: const WalletLookupKey(
  //         chainId: chainId,
  //         password: "password",
  //         walletId: walletId,
  //       ),
  //     );
  //
  //   });
  //
  //   setUp(() {
  //     summaryUI = NoOpTransactionSummaryUI();
  //     infoStorage = KeyInfoStorageMock();
  //     signingGateway = TransactionSigningGateway(
  //       transactionSummaryUI: summaryUI,
  //       signers: [signer],
  //       broadcasters: [],
  //       infoStorage: infoStorage,
  //       derivators: [derivator],
  //     );
  //   });
  // });
}

typedef KeyInfoRetriever
    = Future<Either<CredentialsStorageFailure, PrivateAccountCredentials>>
        Function(
  String,
  String,
  String,
);

class KeyInfoStorageMock extends Mock implements KeyInfoStorage {
  KeyInfoRetriever keyInfoRetriever;

  KeyInfoStorageMock({
    KeyInfoRetriever? retriever,
  }) : keyInfoRetriever = retriever ??
            ((_, __, ___) async =>
                left(const CredentialsStorageFailure("not implemented")));

  @override
  Future<
      Either<CredentialsStorageFailure,
          PrivateAccountCredentials>> getPrivateCredentials(
    AccountLookupKey? walletLookupKey,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #getPrivateCredentials,
          [
            walletLookupKey,
          ],
          {},
        ),
        returnValue: Future<
            Either<CredentialsStorageFailure, PrivateAccountCredentials>>.value(
          left(const CredentialsStorageFailure("not mocked")),
        ),
      ) as Future<Either<CredentialsStorageFailure, PrivateAccountCredentials>>;
}
