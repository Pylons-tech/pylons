import 'package:dartz/dartz.dart';
import 'package:transaction_signing_gateway/model/transaction_signing_failure.dart';
import 'package:transaction_signing_gateway/model/unsigned_transaction.dart';
import 'package:transaction_signing_gateway/transaction_summary_ui.dart';

/// Transaction summary UI that displays nothing and immediately proceeds with "success" user confirmation
class NoOpTransactionSummaryUI implements TransactionSummaryUI {
  @override
  Future<Either<TransactionSigningFailure, Unit>> showTransactionSummaryUI({
    required UnsignedTransaction transaction,
  }) async {
    return right(unit);
  }
}
