import 'package:dartz/dartz.dart';
import 'package:transaction_signing_gateway/model/transaction_signing_failure.dart';
import 'package:transaction_signing_gateway/model/unsigned_transaction.dart';

abstract class TransactionSummaryUI {
  /// Shows a summary of the transaction for the user to approve.
  ///
  /// Implementations of this method should display a summary of the transaction that is about to be signed.
  /// This method allows the user to review all of the relevant details and present them with options to approve
  /// or decline the transaction. If the transaction is declined, the returned [Future] emits
  /// `left(UserDeclinedTransactionSignerFailure)`, otherwise a `right(unit)` denotes a success.
  Future<Either<TransactionSigningFailure, Unit>> showTransactionSummaryUI({
    required UnsignedTransaction transaction,
  });
}
