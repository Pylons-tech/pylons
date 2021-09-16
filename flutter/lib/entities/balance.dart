import 'package:equatable/equatable.dart';
import 'package:pylons_wallet/entities/amount.dart';
import 'package:pylons_wallet/entities/denom.dart';

class Balance extends Equatable {
  final Denom denom;
  final Amount amount;

  const Balance({
    required this.denom,
    required this.amount,
  });

  Balance.fromJSON(Map<String,dynamic> json) :
          denom = Denom(json['denom'] as String),
          amount = Amount.fromString(json['amount'] as String);

  @override
  String toString() => '$amount $denom';

  @override
  List<Object> get props => [
        denom,
        amount,
      ];


}
