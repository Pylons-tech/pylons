import 'package:equatable/equatable.dart';
import 'package:pylons_wallet/model/amount.dart';

class Balance extends Equatable {
  final String denom;
  final Amount amount;

  const Balance({
    required this.denom,
    required this.amount,
  });

  Balance.fromJSON(Map<String, dynamic> json)
      : denom = json['denom'] as String,
        amount = Amount.fromString(json['amount'] as String);

  @override
  String toString() => '$amount $denom';

  @override
  List<Object> get props => [
        denom,
        amount,
      ];

  Map<String, dynamic> toJson() =>
      {'denom': denom, 'amount': amount.displayText};
}
