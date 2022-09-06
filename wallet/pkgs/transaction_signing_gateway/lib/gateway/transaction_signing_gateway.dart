import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:transaction_signing_gateway/account_derivator.dart';
import 'package:transaction_signing_gateway/alan/alan_account_derivator.dart';
import 'package:transaction_signing_gateway/mobile/no_op_transaction_summary_ui.dart';
import 'package:transaction_signing_gateway/model/account_derivation_failure.dart';
import 'package:transaction_signing_gateway/model/account_derivation_info.dart';
import 'package:transaction_signing_gateway/model/account_lookup_key.dart';
import 'package:transaction_signing_gateway/model/clear_credentials_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_broadcasting_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_response.dart';
import 'package:transaction_signing_gateway/model/transaction_signing_failure.dart';
import 'package:transaction_signing_gateway/transaction_broadcaster.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/transaction_summary_ui.dart';

class TransactionSigningGateway {
  TransactionSigningGateway({
    List<TransactionSigner>? signers,
    List<TransactionBroadcaster>? broadcasters,
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
        _transactionSummaryUI = transactionSummaryUI ?? NoOpTransactionSummaryUI();

  final List<TransactionSigner> _signers;
  final List<TransactionBroadcaster> _broadcasters;
  final List<AccountDerivator> _derivators;
  final KeyInfoStorage _infoStorage;

  final TransactionSummaryUI _transactionSummaryUI;

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

  /// Deletes a account from device
  Future<Either<CredentialsStorageFailure, Unit>> deleteAccountCredentials({required AccountPublicInfo publicInfo}) =>
      _infoStorage.deleteAccountCredentials(publicInfo: publicInfo);

  /// Updates the public details of the account
  Future<Either<CredentialsStorageFailure, Unit>> updateAccountPublicInfo({
    required AccountPublicInfo info,
  }) =>
      _infoStorage.updatePublicAccountInfo(info: info);

  /// Signs the passed [transaction].
  ///
  /// This function triggers the entire signing flow, where a transaction summary is first shown to the user.
  /// If the transaction is accepted, the workflow looks for a capable [TransactionSigner].
  /// After a credentials retrieval and transaction signing is successful, a [SignedTransaction] object is output.
  /// If any of the steps fail, a [TransactionSigningFailure] is returned.
  Future<Either<TransactionSigningFailure, SignedTransaction>> signTransaction({
    required UnsignedTransaction transaction,
    required AccountLookupKey accountLookupKey,
  }) async =>
      _transactionSummaryUI
          .showTransactionSummaryUI(transaction: transaction)
          .flatMap(
            (userAccepted) => _infoStorage
                .getPrivateCredentials(accountLookupKey)
                .leftMap((err) => left(StorageProblemSigningFailure(err))),
          )
          .flatMap(
            (privateCreds) async => _findCapableSigner(transaction).sign(
              privateCredentials: privateCreds,
              transaction: transaction,
            ),
          );

  Future<Either<TransactionBroadcastingFailure, TransactionResponse>> broadcastTransaction({
    required AccountLookupKey accountLookupKey,
    required SignedTransaction transaction,
  }) async =>
      _infoStorage
          .getPrivateCredentials(accountLookupKey)
          .leftMap<TransactionBroadcastingFailure>((err) => left(StorageProblemBroadcastingFailure()))
          .flatMap(
            (privateCreds) async => _findCapableBroadcaster(transaction).broadcast(
              transaction: transaction,
              privateAccountCredentials: privateCreds,
            ),
          );

  Future<Either<AccountDerivationFailure, PrivateAccountCredentials>> deriveAccount({
    required AccountDerivationInfo accountDerivationInfo,
  }) async =>
      _findCapableDerivator(accountDerivationInfo).derive(accountDerivationInfo: accountDerivationInfo);

  Future<Either<CredentialsStorageFailure, List<AccountPublicInfo>>> getAccountsList() =>
      _infoStorage.getAccountsList();

  /// Verifies if passed lookupKey is pointing to a valid account stored within the secure storage.
  Future<Either<TransactionSigningFailure, bool>> verifyLookupKey(AccountLookupKey accountLookupKey) =>
      _infoStorage.verifyLookupKey(accountLookupKey);

  TransactionSigner _findCapableSigner(UnsignedTransaction transaction) => _signers.firstWhere(
        (element) => element.canSign(transaction),
        orElse: NotFoundTransactionSigner.new,
      );

  TransactionBroadcaster _findCapableBroadcaster(SignedTransaction transaction) => _broadcasters.firstWhere(
        (element) => element.canBroadcast(transaction),
        orElse: NotFoundBroadcaster.new,
      );

  AccountDerivator _findCapableDerivator(AccountDerivationInfo accountDerivationInfo) => _derivators.firstWhere(
        (element) => element.canDerive(accountDerivationInfo),
        orElse: NotFoundDerivator.new,
      );

  /// Removes all stored account's data. If it fails, a [ClearCredentialsFailure] is returned.
  Future<Either<ClearCredentialsFailure, Unit>> clearAllCredentials() => _infoStorage.clearCredentials();
}
