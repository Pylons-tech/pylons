import 'package:dartz/dartz.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';
import 'package:transaction_signing_gateway/model/signed_transaction.dart';
import 'package:transaction_signing_gateway/model/transaction_broadcasting_failure.dart';
import 'package:transaction_signing_gateway/model/transaction_response.dart';

abstract class TransactionBroadcaster {
  Future<Either<TransactionBroadcastingFailure, TransactionResponse>> broadcast({
    required SignedTransaction transaction,
    required PrivateAccountCredentials privateAccountCredentials,
  });

  bool canBroadcast(SignedTransaction signedTransaction);
}

class NotFoundBroadcaster implements TransactionBroadcaster {
  @override
  Future<Either<TransactionBroadcastingFailure, TransactionResponse>> broadcast({
    required SignedTransaction transaction,
    required PrivateAccountCredentials privateAccountCredentials,
  }) async =>
      left(TransactionBroadcasterNotFoundFailure());

  @override
  bool canBroadcast(SignedTransaction signedTransaction) => true;
}
