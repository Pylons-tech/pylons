import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';

class Currency {
  final String amount;
  final String asset;
  final String currency;
  final String abbrev;
  final bool isDefault;
  final IBCCoins ibcCoins;

  Currency(
      {required this.amount,
      required this.asset,
      required this.currency,
      required this.abbrev,
        required this.ibcCoins,
      required this.isDefault});
}
