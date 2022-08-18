class TransactionResponse {
  String hash;

  TransactionResponse({required this.hash});

  factory TransactionResponse.initial() {
    return TransactionResponse(hash: '');
  }
}
