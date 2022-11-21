import 'package:pylons_wallet/utils/constants.dart';

class NftOwnershipHistory {
  final String itemID;
  final String cookbookID;
  final String senderName;
  final String receiverID;
  final int createdAt;

  NftOwnershipHistory(
      {required this.itemID, required this.cookbookID, required this.senderName, required this.receiverID, required this.createdAt});

  factory NftOwnershipHistory.fromJson(Map<String, dynamic> json) {
    final itemID = json[kItemId] as String;
    final cookbookID = json[kCookbookId] as String;
    final senderName = json[kFrom] as String;
    final receiver = json[kTo] as String;
    final createdAt = int.parse(json[kCreatedAt] as String);
    return NftOwnershipHistory(
      receiverID: receiver,
      cookbookID: cookbookID,
      senderName: senderName,
      itemID: itemID,
      createdAt: createdAt,
    );
  }

  factory NftOwnershipHistory.fromCookBookAndRecipeJson(Map<String, dynamic> json) {
    final itemID = json[kItemIdKey] as String;
    final cookbookID = json[kCookbookId] as String;
    final senderName = json[kSenderName] as String;
    final receiver = json[kReceiver] as String;
    final createdAt = int.parse(json[kCreatedAt] as String);
    return NftOwnershipHistory(
      receiverID: receiver,
      cookbookID: cookbookID,
      senderName: senderName,
      itemID: itemID,
      createdAt: createdAt,
    );
  }

}
