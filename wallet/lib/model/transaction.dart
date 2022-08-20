import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/utils/constants.dart';

class TransactionHistory {
  final String txID;
  final String address;
  final String amount;
  final String cookbookId;
  final String recipeId;
  final int createdAt;
  final String transactionType;
  final IBCCoins ibcCoin;

  final TransactionType transactionTypeEnum;

  TransactionHistory({
    required this.txID,
    required this.address,
    required this.amount,
    required this.cookbookId,
    required this.recipeId,
    required this.createdAt,
    required this.ibcCoin,
    required this.transactionType,
    required this.transactionTypeEnum,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) =>
      TransactionHistory(
          txID: json[kTxId] as String,
          address: json[kAddressKey] as String,
          amount: json[kAmountKey].toString() != "0"
              ? json[kAmountKey] as String
              : "0$kPylonDenom",
          cookbookId: json.containsKey(kCookbookIdKey)
              ? json[kCookbookIdKey] as String
              : "",
          recipeId: json.containsKey(kRecipeIdKey)
              ? json[kRecipeIdKey] as String
              : "",
          createdAt: json[kCreatedAtKey] as int,
          transactionType: json[kTypeKey] as String,
          transactionTypeEnum:
              TransactionType.values.byName(json[kTypeKey] as String),
          ibcCoin: json[kAmountKey].toString() != "0"
              ? splitNumberAndAlpha(json[kAmountKey] as String)[1]
                  .toIBCCoinsEnum()
              : IBCCoins.upylon);

  static bool isFreeDrop(String amount) => amount == "0";

  static List<String> splitNumberAndAlpha(String input) => <String>[
        ...RegExp(r'\d+|\D+')
            .allMatches(input)
            .map((match) => match[0]!)
            .map((string) => string)
      ];
}

enum TransactionType { SEND, RECEIVE, NFTBUY, NFTSELL }
