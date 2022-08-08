import 'package:pylons_wallet/utils/constants.dart';

class NftOwnershipHistory {
  final String itemID;
  final String cookbookID;
  final String recipeID;
  final String sender;
  final String senderName;
  final String receiver;
  final String amount;
  final int createdAt;

  NftOwnershipHistory(
      {required this.itemID,
      required this.cookbookID,
      required this.recipeID,
      required this.sender,
      required this.senderName,
      required this.receiver,
      required this.amount,
      required this.createdAt});

  factory NftOwnershipHistory.fromJson(Map<String, dynamic> json) {
    final itemID = json[kItemId] as String;
    final cookbookID = json[kCookbookId] as String;
    final recipeID = json[kRecipe_id] as String;
    final sender = json[kSender] as String;
    final senderName = json[kSenderName] as String;
    final receiver = json[kReceiver] as String;
    final amount = json[kAmount] as String;
    final createdAt = int.parse(json[kCreatedAt] as String);
    return NftOwnershipHistory(
        receiver: receiver,
        cookbookID: cookbookID,
        amount: amount,
        sender: sender,
        senderName: senderName,
        itemID: itemID,
        createdAt: createdAt,
        recipeID: recipeID);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ItemID'] = itemID;
    data['CookbookID'] = cookbookID;
    data['RecipeID'] = recipeID;
    data['sender'] = sender;
    data['senderName'] = senderName;
    data['receiver'] = receiver;
    data['amount'] = amount;
    data['createdAt'] = createdAt;
    return data;
  }
}
