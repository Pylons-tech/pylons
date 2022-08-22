/// denom : "pylon"
/// amount : "12"

class Coins {
  late String denom;
  late String amount;

  Coins({required this.denom, required this.amount});

  Coins.fromJson(dynamic json) {
    denom = json['denom'] as String;
    amount = json['amount'] as String;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['denom'] = denom;
    map['amount'] = amount;
    return map;
  }
}
