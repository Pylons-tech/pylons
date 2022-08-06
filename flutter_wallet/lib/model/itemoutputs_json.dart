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

class ItemOutputs {
  late String id;
  late List<Doubles> doubles;
  late List<Longs> longs;
  late List<Strings> strings;
  late List<dynamic> mutableStrings;
  late List<dynamic> transferFee;
  late String tradePercentage;
  late String quantity;
  late String amountMinted;
  late bool tradeable;

  ItemOutputs({
    required this.id,
    required this.doubles,
    required this.longs,
    required this.strings,
    required this.mutableStrings,
    required this.transferFee,
    required this.tradePercentage,
    required this.quantity,
    required this.amountMinted,
    required this.tradeable,
  });

  ItemOutputs.fromJson(dynamic json) {
    id = json['ID'] as String;
    if (json['doubles'] != null) {
      doubles = [];
      json['doubles'].forEach((v) {
        doubles.add(Doubles.fromJson(v));
      });
    }
    if (json['longs'] != null) {
      longs = [];

      for( final longsJson in json['longs']){
        longs.add(Longs.fromJson(longsJson));
      }

    }
    if (json['strings'] != null) {
      strings = [];

      for( final stringsJson in json['strings']){


        if(stringsJson is Map<String, dynamic>){
          strings.add(Strings.fromJson(stringsJson));
        }
      }
    }
    if (json['mutableStrings'] != null) {
      mutableStrings = [];
      // for( final mutableStringsJson in json['mutableStrings']){
      //   // mutableStrings.add(dynamic.fromJson(v));
      // }

    }
    if (json['transferFee'] != null) {
      transferFee = [];
      for( final transferFeeJson in json['transferFee']){
        transferFee.add(Coins.fromJson(transferFeeJson));
      }
    }
    tradePercentage = json['tradePercentage'] as String;
    quantity = json['quantity'] as String;
    amountMinted = json['amountMinted'] as String;
    tradeable = json['tradeable'] as bool;
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
    map['quantity'] = quantity;
    map['amountMinted'] = amountMinted;
    map['tradeable'] = tradeable;
    return map;
  }
}
