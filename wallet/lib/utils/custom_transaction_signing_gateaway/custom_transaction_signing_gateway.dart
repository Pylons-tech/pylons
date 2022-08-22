import 'dart:convert';
import 'dart:typed_data';

import 'package:alan/wallet/network_info.dart';
import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:pylons_wallet/stores/models/transaction_response.dart';
import 'package:pylons_wallet/utils/custom_transaction_broadcaster/custom_transaction_broadcaster.dart';
import 'package:transaction_signing_gateway/account_derivator.dart';
import 'package:transaction_signing_gateway/alan/alan_account_derivator.dart';
import 'package:transaction_signing_gateway/mobile/no_op_transaction_summary_ui.dart';
import 'package:transaction_signing_gateway/model/account_derivation_failure.dart';
import 'package:transaction_signing_gateway/model/account_derivation_info.dart';
import 'package:transaction_signing_gateway/model/account_lookup_key.dart';
import 'package:transaction_signing_gateway/model/clear_credentials_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_broadcasting_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_signing_failure.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/transaction_summary_ui.dart';

class CustomTransactionSigningGateway {
  final List<TransactionSigner> _signers;
  final List<CustomTransactionBroadcaster> _broadcasters;
  final List<AccountDerivator> _derivators;
  final KeyInfoStorage _infoStorage;
  final TransactionSummaryUI _transactionSummaryUI;

  CustomTransactionSigningGateway({
    List<TransactionSigner>? signers,
    List<CustomTransactionBroadcaster>? broadcasters,
    KeyInfoStorage? infoStorage,
    TransactionSummaryUI? transactionSummaryUI,
    List<AccountDerivator>? derivators,
  })  : _signers = List.unmodifiable(signers ?? []),
        _broadcasters = List.unmodifiable(broadcasters ?? []),
        _derivators = List.unmodifiable(derivators ?? [AlanAccountDerivator()]),
        _infoStorage = infoStorage ??
            CosmosKeyInfoStorage(
              serializers: [AlanCredentialsSerializer()],
              plainDataStore: SharedPrefsPlainDataStore(),
              secureDataStore: FlutterSecureStorageDataStore(),
            ),
        _transactionSummaryUI =
            transactionSummaryUI ?? NoOpTransactionSummaryUI();

  /// Stores the passed-in wallet credentials securely on the device.
  ///
  /// The `secure_storage` package and strong encryption are used internally,  where [password] is used to generate the
  /// encryption key. Password IS NOT STORED but is passed every time in order to access the private credentials.
  /// [WalletPublicInfo], part of the [PrivateWalletCredentials], is accessible without a password.
  Future<Either<CredentialsStorageFailure, Unit>> storeWalletCredentials({
    required PrivateAccountCredentials credentials,
    required String password,
  }) =>
      _infoStorage.savePrivateCredentials(
        accountCredentials: credentials,
        password: password,
      );

  /// Signs the passed [transaction].
  ///
  /// This function triggers the entire signing flow, where a transaction summary is first shown to the user.
  /// If the transaction is accepted, the workflow looks for a capable [TransactionSigner].
  /// After a credentials retrieval and transaction signing is successful, a [SignedTransaction] object is output.
  /// If any of the steps fail, a [TransactionSigningFailure] is returned.
  Future<Either<TransactionSigningFailure, SignedTransaction>> signTransaction({
    required UnsignedTransaction transaction,
    required AccountLookupKey walletLookupKey,
  }) async =>
      _transactionSummaryUI
          .showTransactionSummaryUI(transaction: transaction)
          .flatMap(
            (userAccepted) => _infoStorage
                .getPrivateCredentials(walletLookupKey)
                .leftMap((err) => left(StorageProblemSigningFailure(err))),
          )
          .flatMap(
            (privateCreds) async => _findCapableSigner(transaction).sign(
              privateCredentials: privateCreds,
              transaction: transaction,
            ),
          );

  Future<String> signPureMessage(
      {required NetworkInfo networkInfo,
      required AccountLookupKey walletLookupKey,
      required String msg}) async {
    final retCreds = await _infoStorage.getPrivateCredentials(walletLookupKey);
    if (retCreds.isRight()) {
      final creds = retCreds.toOption().toNullable();
      if (creds != null) {
        final wallet =
            (creds as AlanPrivateAccountCredentials).alanAccount(networkInfo);
        final list = utf8.encode(msg);
        final bytes = Uint8List.fromList(list);
        final signedMsg = wallet.sign(bytes);
        return base64Encode(signedMsg);
      }
    }
    return "";
  }

  Future<Either<TransactionBroadcastingFailure, TransactionResponse>>
      broadcastTransaction({
    required AccountLookupKey walletLookupKey,
    required SignedTransaction transaction,
  }) async =>
          _infoStorage
              .getPrivateCredentials(walletLookupKey)
              .leftMap<TransactionBroadcastingFailure>(
                  (err) => left(StorageProblemBroadcastingFailure()))
              .flatMap(
                (privateCreds) async =>
                    _findCapableBroadcaster(transaction).broadcast(
                  transaction: transaction,
                  privateWalletCredentials: privateCreds,
                ),
              );

  /// Stores the passed-in account credentials securely on the device.
  ///
  /// The `secure_storage` package and strong encryption are used internally,  where [password] is used to generate the
  /// encryption key. Password IS NOT STORED but is passed every time in order to access the private credentials.
  /// [AccountPublicInfo], part of the [PrivateAccountCredentials], is accessible without a password.
  Future<Either<CredentialsStorageFailure, Unit>> storeAccountCredentials({
    required PrivateAccountCredentials credentials,
    required String password,
    String? additionalData,
  }) =>
      _infoStorage.savePrivateCredentials(
        accountCredentials: credentials,
        password: password,
      );

  /// delete the passed-in account credentials securely on the device.
  /// [AccountPublicInfo], part of the [PrivateAccountCredentials], is used to delete credentials.
  Future<Either<CredentialsStorageFailure, Unit>> deleteAccountCredentials({
    required AccountPublicInfo info,
  }) =>
      _infoStorage.deleteAccountCredentials(
        publicInfo: info,
      );

  Future<Either<AccountDerivationFailure, PrivateAccountCredentials>>
      deriveWallet({
    required AccountDerivationInfo walletDerivationInfo,
  }) async =>
          _findCapableDerivator(walletDerivationInfo)
              .derive(accountDerivationInfo: walletDerivationInfo);

  Future<Either<CredentialsStorageFailure, List<AccountPublicInfo>>>
      getWalletsList() => _infoStorage.getAccountsList();

  /// Verifies if passed lookupKey is pointing to a valid wallet stored within the secure storage.
  Future<Either<TransactionSigningFailure, bool>> verifyLookupKey(
          AccountLookupKey walletLookupKey) =>
      _infoStorage.verifyLookupKey(walletLookupKey);

  TransactionSigner _findCapableSigner(UnsignedTransaction transaction) =>
      _signers.firstWhere(
        (element) => element.canSign(transaction),
        orElse: () => NotFoundTransactionSigner(),
      );

  CustomTransactionBroadcaster _findCapableBroadcaster(
          SignedTransaction transaction) =>
      _broadcasters.firstWhere(
        (element) => element.canBroadcast(transaction),
        orElse: () => CustomNotFoundBroadcaster(),
      );

  AccountDerivator _findCapableDerivator(
          AccountDerivationInfo walletDerivationInfo) =>
      _derivators.firstWhere(
        (element) => element.canDerive(walletDerivationInfo),
        orElse: () => NotFoundDerivator(),
      );

  /// Removes all stored account's data. If it fails, a [ClearCredentialsFailure] is returned.
  Future<Either<ClearCredentialsFailure, Unit>> clearAllCredentials() =>
      _infoStorage.clearCredentials();
}
