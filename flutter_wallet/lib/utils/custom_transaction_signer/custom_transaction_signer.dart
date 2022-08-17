import 'package:alan/alan.dart';
import 'package:dartz/dartz.dart';
import 'package:pylons_wallet/utils/custom_transaction_signer/custom_tx_signer.dart';
import 'package:transaction_signing_gateway/alan/alan_private_account_credentials.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction.dart';
import 'package:transaction_signing_gateway/model/private_account_credentials.dart';
import 'package:transaction_signing_gateway/model/signed_transaction.dart';
import 'package:transaction_signing_gateway/model/transaction_signing_failure.dart';
import 'package:transaction_signing_gateway/model/unsigned_transaction.dart';
import 'package:transaction_signing_gateway/transaction_signer.dart';


class CustomTransactionSigner implements TransactionSigner {
  final NetworkInfo _networkInfo;

  CustomTransactionSigner(this._networkInfo);

  @override
  bool canSign(UnsignedTransaction unsignedTransaction) =>
      unsignedTransaction is UnsignedAlanTransaction;

  @override
  Future<Either<TransactionSigningFailure, SignedTransaction>> sign({
    required PrivateAccountCredentials privateCredentials,
    required UnsignedTransaction transaction,
  }) async {
    if (transaction is! UnsignedAlanTransaction) {
      return left(CustomTransactionSignerFailure(
          "passed transaction is not $UnsignedAlanTransaction"));
    }
    if (privateCredentials is! AlanPrivateAccountCredentials) {
      return left(CustomTransactionSignerFailure(
          "passed privateCredentials is not $AlanPrivateAccountCredentials"));
    }

    try {
      final signer = CustomTxSigner.fromNetworkInfo(_networkInfo.chainId);
      final signedTrans = await signer.createAndSign(
        privateCredentials.alanAccount(_networkInfo),
        transaction.messages,
        memo: transaction.memo,
        fee: transaction.fee,
      );
      return right(SignedAlanTransaction(signedTransaction: signedTrans));
    } catch (error, _) {
      return left(CustomTransactionSignerFailure(error));
    }
  }
}

class CustomTransactionSignerFailure extends TransactionSigningFailure {
  final Object cause;

  CustomTransactionSignerFailure(this.cause);

  @override
  TransactionSigningFailType get type => TransactionSigningFailType.unknown;

  @override
  String toString() {
    return 'AlanTransactionSigningFailure{cause: $cause}';
  }
}
