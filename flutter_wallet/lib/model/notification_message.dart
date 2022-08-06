import 'package:pylons_wallet/utils/constants.dart';

class NotificationMessage {
  final String id;
  final String txHash;
  final int amount;
  final String coin;
  final int createdAt;
  final String from;
  final String itemFormat;
  final String itemImg;
  final String itemName;
  final bool read;
  final bool settled;
  final String to;
  final String type;
  final int? updatedAt;

  NotificationMessage(
      {required this.id,
      required this.txHash,
      required this.amount,
      required this.coin,
      required this.createdAt,
      required this.from,
      required this.itemFormat,
      required this.itemImg,
      required this.itemName,
      required this.read,
      required this.settled,
      required this.to,
      required this.type,
      required this.updatedAt});

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    final id = json[kMsgId] as String;
    final txHash = json[kTxHash] as String;
    final amount = json[kAmount] == null ? 0 : json[kAmount] as int;
    final coin = json[kCoin] as String;
    final createdAt = json[kCreatedAt] as int;
    final from = json[kFrom] as String;
    final itemFormat = json[kItemFormat] as String;
    final itemImg = json[kItemImg] as String;
    final itemName = json[kItemName] as String;
    final read = json[kRead] as bool;
    final settled = json[kSettled] as bool;
    final to = json[kTo] as String;
    final type = json[kType] as String;
    final updatedAt = json[kUpdatedAt] as int;
    return NotificationMessage(id: id, txHash: txHash , amount: amount, coin: coin, createdAt: createdAt, from: from, itemFormat: itemFormat, itemImg: itemImg, read: read, settled: settled, to: to, type: type, updatedAt: updatedAt, itemName: itemName);
  }

  @override
  String toString() {
    return 'NotificationMessage{id: $id, txHash: $txHash, amount: $amount, coin: $coin, createdAt: $createdAt, from: $from, itemFormat: $itemFormat, itemImg: $itemImg, itemName: $itemName, read: $read, settled: $settled, to: $to, type: $type, updatedAt: $updatedAt}';
  }
}
