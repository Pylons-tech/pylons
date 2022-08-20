import 'package:alan/alan.dart';
import 'package:dartz/dartz.dart';
import 'package:pylons_wallet/stores/models/transaction_response.dart';
import 'package:pylons_wallet/utils/custom_transaction_broadcaster/custom_transaction_broadcaster.dart';
import 'package:transaction_signing_gateway/alan/alan_private_account_credentials.dart';

import 'package:transaction_signing_gateway/alan/alan_transaction.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';

import 'package:transaction_signing_gateway/model/signed_transaction.dart';
import 'package:transaction_signing_gateway/model/transaction_broadcasting_failure.dart';

class CustomTransactionBroadcasterImp implements CustomTransactionBroadcaster {
  final NetworkInfo _networkInfo;

  CustomTransactionBroadcasterImp(this._networkInfo);

  @override
  bool canBroadcast(SignedTransaction signedTransaction) =>
      signedTransaction is SignedAlanTransaction;

  @override
  Future<Either<TransactionBroadcastingFailure, TransactionResponse>> broadcast(
      {required SignedTransaction transaction,
      required PrivateAccountCredentials privateWalletCredentials}) async {
    if (transaction is! SignedAlanTransaction) {
      return left(CustomTransactionBroadcastingFailure(
          'passed transaction is not $SignedAlanTransaction'));
    }
    if (privateWalletCredentials is! AlanPrivateAccountCredentials) {
      return left(CustomTransactionBroadcastingFailure(
          "passed privateCredentials is not $AlanPrivateAccountCredentials"));
    }
    final txSender = TxSender.fromNetworkInfo(_networkInfo);
    final response = await txSender.broadcastTx(transaction.signedTransaction,
        mode: BroadcastMode.BROADCAST_MODE_BLOCK);

    if (response.hasCode()) {
      if (response.code != 0) {
        return left(CustomTransactionBroadcastingFailure(
            'Tx error:${response.code} ${response.rawLog}'));
      }
    }

    if (response.hasTxhash()) {
      return right(TransactionResponse(hash: response.txhash));
    } else {
      return left(CustomTransactionBroadcastingFailure('Tx error: $response'));
    }
  }
}

class CustomTransactionBroadcastingFailure
    extends TransactionBroadcastingFailure {
  final Object cause;

  CustomTransactionBroadcastingFailure(this.cause);

  @override
  String toString() {
    return 'Transaction Failure {cause: $cause}';
  }

  @override
  // TODO: implement type
  TransactionBroadcastingFailType get type =>
      TransactionBroadcastingFailType.unknown;
}
