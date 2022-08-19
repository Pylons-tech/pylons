import 'package:dartz/dartz.dart';
import 'package:pylons_wallet/stores/models/transaction_response.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';

import 'package:transaction_signing_gateway/model/signed_transaction.dart';
import 'package:transaction_signing_gateway/model/transaction_broadcasting_failure.dart';

abstract class CustomTransactionBroadcaster {
  Future<Either<TransactionBroadcastingFailure, TransactionResponse>>
      broadcast({
    required SignedTransaction transaction,
    required PrivateAccountCredentials privateWalletCredentials,
  });

  bool canBroadcast(SignedTransaction signedTransaction);
}

class CustomNotFoundBroadcaster implements CustomTransactionBroadcaster {
  @override
  Future<Either<TransactionBroadcastingFailure, TransactionResponse>>
      broadcast({
    required SignedTransaction transaction,
    required PrivateAccountCredentials privateWalletCredentials,
  }) async =>
          left(TransactionBroadcasterNotFoundFailure());

  @override
  bool canBroadcast(SignedTransaction signedTransaction) => true;
}
