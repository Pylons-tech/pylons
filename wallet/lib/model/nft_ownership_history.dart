import 'package:pylons_wallet/utils/constants.dart';

class NftOwnershipHistory {
  final String itemID;
  final String cookbookID;
  final String senderName;
  final String receiver;
  final int createdAt;

  NftOwnershipHistory(
      {required this.itemID, required this.cookbookID, required this.senderName, required this.receiver, required this.createdAt});

  factory NftOwnershipHistory.fromJson(Map<String, dynamic> json) {
    final itemID = json[kItemId] as String;
    final cookbookID = json[kCookbookId] as String;
    final senderName = json[kFrom] as String;
    final receiver = json[kTo] as String;
    final createdAt = int.parse(json[kCreatedAt] as String);
    return NftOwnershipHistory(
      receiver: receiver,
      cookbookID: cookbookID,
      senderName: senderName,
      itemID: itemID,
      createdAt: createdAt,
    );
  }

}
