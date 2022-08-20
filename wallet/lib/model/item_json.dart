import 'package:fixnum/fixnum.dart';
import 'package:pylons_wallet/model/coins_json.dart';
import 'package:pylons_wallet/model/doubles_json.dart';
import 'package:pylons_wallet/model/longs_json.dart';
import 'package:pylons_wallet/model/strings_json.dart';

/// ID : "title_title"
/// doubles : [{"key":"Residual","rate":"0.000000000000000001","weightRanges":[{"lower":"2000000000000000000.000000000000000000","upper":"2000000000000000000.000000000000000000","weight":"1"}],"program":"1"}]
/// longs : [{"key":"Quantity","rate":"0.000000000000000001","weightRanges":[{"lower":"23","upper":"23","weight":"1"}],"program":"1"},{"key":"Width","rate":"0.000000000000000001","weightRanges":[{"lower":"1920","upper":"1920","weight":"1"}],"program":""},{"key":"Height","rate":"0.000000000000000001","weightRanges":[{"lower":"1288","upper":"1288","weight":"1"}],"program":"1"}]
/// strings : [{"key":"Name","rate":"0.000000000000000001","value":"title title","program":""},{"key":"NFT_URL","rate":"0.000000000000000001","value":"https://www.imagesource.com/wp-content/uploads/2019/06/Rio.jpg","program":""},{"key":"Description","rate":"0.000000000000000001","value":"aaaaaaaaassasssssssssss\n","program":""},{"key":"Currency","rate":"0.000000000000000001","value":"pylon","program":""},{"key":"Price","rate":"0.000000000000000001","value":"12","program":"1"}]
/// mutableStrings : []
/// transferFee : []
/// tradePercentage : "0.000000000000000001"
/// quantity : "23"
/// amountMinted : "2"
/// tradeable : true

class Item {
  late String owner;
  late String cookbookID;
  late String id;
  late String nodeVersion;
  late List<Doubles> doubles;
  late List<Longs> longs;
  late List<Strings> strings;
  late List<dynamic> mutableStrings;
  late List<dynamic> transferFee;
  late String tradePercentage;
  late Int64 lastUpdate;
  late bool tradeable;

  Item(
      {required this.owner,
      required this.cookbookID,
      required this.id,
      required this.nodeVersion,
      required this.doubles,
      required this.longs,
      required this.strings,
      required this.mutableStrings,
      required this.transferFee,
      required this.tradePercentage,
      required this.lastUpdate,
      required this.tradeable});

  Item.fromJson(dynamic json) {
    id = json['ID'] as String;
    cookbookID = json['cookbookID'] as String;
    owner = json['owner'] as String;
    nodeVersion = json['nodeVersion'] as String;

    if (json['doubles'] != null) {
      doubles = [];
      json['doubles'].forEach((v) {
        doubles.add(Doubles.fromJson(v));
      });
    }
    if (json['longs'] != null) {
      longs = [];
      json['longs'].forEach((v) {
        longs.add(Longs.fromJson(v));
      });
    }
    if (json['strings'] != null) {
      strings = [];
      json['strings'].forEach((v) {
        if (v is Map<String, dynamic>) {
          strings.add(Strings.fromJson(v));
        }
      });
    }
    if (json['mutableStrings'] != null) {
      mutableStrings = [];
      json['mutableStrings'].forEach((v) {
        // mutableStrings.add(dynamic.fromJson(v));
      });
    }
    if (json['transferFee'] != null) {
      transferFee = [];
      json['transferFee'].forEach((v) {
        transferFee.add(Coins.fromJson(v));
      });
    }
    tradePercentage = json['tradePercentage'] as String;
    tradeable = json['tradeable'] as bool;
    lastUpdate = Int64.parseInt(json['lastUpdate'] as String);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = id;
    map['doubles'] = doubles.map((v) => v.toJson()).toList();
    map['longs'] = longs.map((v) => v.toJson()).toList();
    map['strings'] = strings.map((v) => v.toJson()).toList();
    map['mutableStrings'] = mutableStrings.map((v) => v.toJson()).toList();
    map['transferFee'] = transferFee.map((v) => v.toJson()).toList();
    map['tradePercentage'] = tradePercentage;
    map['tradeable'] = tradeable;
    map['lastUpdate'] = lastUpdate.toString();
    map['owner'] = owner;
    map['coobookID'] = cookbookID;
    map['nodeVersion'] = nodeVersion;
    return map;
  }
}
