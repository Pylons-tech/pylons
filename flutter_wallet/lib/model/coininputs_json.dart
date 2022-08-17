import 'package:pylons_wallet/model/coins_json.dart';

/// coins : [{"denom":"pylon","amount":"12"}]

class CoinInputs {
  late List<Coins> coins;

  CoinInputs({
    required this.coins,
  });

  CoinInputs.fromJson(Map<String, dynamic> json) {
    if (json['coins'] != null) {
      coins = [];


      for(final coin in json['coins']){
        coins.add(Coins.fromJson(coin));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['coins'] = coins.map((v) => v.toJson()).toList();
    return map;
  }
}
