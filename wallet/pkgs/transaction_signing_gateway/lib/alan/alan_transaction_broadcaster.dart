import 'package:alan/alan.dart';
import 'package:dartz/dartz.dart';
import 'package:transaction_signing_gateway/alan/alan_private_account_credentials.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';
import 'package:transaction_signing_gateway/model/signed_transaction.dart';
import 'package:transaction_signing_gateway/model/transaction_broadcasting_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_response.dart';
import 'package:transaction_signing_gateway/transaction_broadcaster.dart';

class AlanTransactionBroadcaster implements TransactionBroadcaster {
  AlanTransactionBroadcaster(this._networkInfo);

  final NetworkInfo _networkInfo;

  @override
  Future<Either<TransactionBroadcastingFailure, TransactionResponse>> broadcast({
    required SignedTransaction transaction,
    required PrivateAccountCredentials privateAccountCredentials,
  }) async {
    if (transaction is! SignedAlanTransaction) {
      return left(AlanTransactionBroadcastingFailure('passed transaction is not $SignedAlanTransaction'));
    }
    if (privateAccountCredentials is! AlanPrivateAccountCredentials) {
      return left(
        AlanTransactionBroadcastingFailure('passed privateCredentials is not $AlanPrivateAccountCredentials'),
      );
    }
    final txSender = TxSender.fromNetworkInfo(_networkInfo);
    final response =
        await txSender.broadcastTx(transaction.signedTransaction, mode: BroadcastMode.BROADCAST_MODE_BLOCK);

    if (response.hasTxhash()) {
      return right(response.toTransactionResponse());
    } else {
      return left(AlanTransactionBroadcastingFailure('Tx error: $response'));
    }
  }

  @override
  bool canBroadcast(SignedTransaction signedTransaction) => signedTransaction is SignedAlanTransaction;
}

class AlanTransactionBroadcastingFailure extends TransactionBroadcastingFailure {
  AlanTransactionBroadcastingFailure(this.cause);

  final Object cause;

  @override
  String toString() {
    return 'AlanTransactionSigningFailure{cause: $cause}';
  }

  @override
  // TODO: implement type
  TransactionBroadcastingFailType get type => TransactionBroadcastingFailType.unknown;
}
