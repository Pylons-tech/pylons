import 'package:alan/alan.dart';
import 'package:equatable/equatable.dart';
import 'package:protobuf/protobuf.dart';
import 'package:transaction_signing_gateway/model/signed_transaction.dart';
import 'package:transaction_signing_gateway/model/unsigned_transaction.dart';

class UnsignedAlanTransaction extends Equatable implements UnsignedTransaction {
  const UnsignedAlanTransaction({
    required this.messages,
    this.memo = '',
    this.fee,
  });

  final List<GeneratedMessage> messages;
  final String memo;

  final Fee? fee;

  @override
  List<Object?> get props => [
        messages,
        memo,
        fee,
      ];
}

class SignedAlanTransaction extends Equatable implements SignedTransaction {
  const SignedAlanTransaction({required this.signedTransaction});

  final Tx signedTransaction;

  @override
  List<Object?> get props => [signedTransaction];
}
