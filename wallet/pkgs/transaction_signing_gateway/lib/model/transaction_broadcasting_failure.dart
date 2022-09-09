enum TransactionBroadcastingFailType {
  noTransactionBroadcasterFound,
  accountCredentialsStorageFailure,
  unknown,
}

abstract class TransactionBroadcastingFailure {
  TransactionBroadcastingFailType get type;
}

class TransactionBroadcasterNotFoundFailure extends TransactionBroadcastingFailure {
  @override
  TransactionBroadcastingFailType get type => TransactionBroadcastingFailType.noTransactionBroadcasterFound;
}

class StorageProblemBroadcastingFailure extends TransactionBroadcastingFailure {
  @override
  // TODO: implement type
  TransactionBroadcastingFailType get type => TransactionBroadcastingFailType.accountCredentialsStorageFailure;
}
