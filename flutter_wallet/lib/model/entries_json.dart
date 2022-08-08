import 'package:pylons_wallet/model/itemoutputs_json.dart';

/// coinOutputs : []
/// itemOutputs : [{"ID":"title_title","doubles":[{"key":"Residual","rate":"0.000000000000000001","weightRanges":[{"lower":"2000000000000000000.000000000000000000","upper":"2000000000000000000.000000000000000000","weight":"1"}],"program":"1"}],"longs":[{"key":"Quantity","rate":"0.000000000000000001","weightRanges":[{"lower":"23","upper":"23","weight":"1"}],"program":"1"},{"key":"Width","rate":"0.000000000000000001","weightRanges":[{"lower":"1920","upper":"1920","weight":"1"}],"program":""},{"key":"Height","rate":"0.000000000000000001","weightRanges":[{"lower":"1288","upper":"1288","weight":"1"}],"program":"1"}],"strings":[{"key":"Name","rate":"0.000000000000000001","value":"title title","program":""},{"key":"NFT_URL","rate":"0.000000000000000001","value":"https://www.imagesource.com/wp-content/uploads/2019/06/Rio.jpg","program":""},{"key":"Description","rate":"0.000000000000000001","value":"aaaaaaaaassasssssssssss\n","program":""},{"key":"Currency","rate":"0.000000000000000001","value":"pylon","program":""},{"key":"Price","rate":"0.000000000000000001","value":"12","program":"1"}],"mutableStrings":[],"transferFee":[],"tradePercentage":"0.000000000000000001","quantity":"23","amountMinted":"2","tradeable":true}]
/// itemModifyOutputs : []

class Entries {
  late List<dynamic> coinOutputs;
  late List<ItemOutputs> itemOutputs;
  late List<dynamic> itemModifyOutputs;

  Entries({
    required this.coinOutputs,
    required this.itemOutputs,
    required this.itemModifyOutputs,
  });

  Entries.fromJson(dynamic json) {
    if (json['coinOutputs'] != null) {
      coinOutputs = [];
      json['coinOutputs'].forEach((v) {
        // coinOutputs.add(dynamic.fromJson(v));
      });
    }
    if (json['itemOutputs'] != null) {
      itemOutputs = [];
      json['itemOutputs'].forEach((v) {
        itemOutputs.add(ItemOutputs.fromJson(v));
      });
    }
    if (json['itemModifyOutputs'] != null) {
      itemModifyOutputs = [];
      json['itemModifyOutputs'].forEach((v) {
        // itemModifyOutputs.add(dynamic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['coinOutputs'] = coinOutputs.map((v) => v.toJson()).toList();
    map['itemOutputs'] = itemOutputs.map((v) => v.toJson()).toList();
    map['itemModifyOutputs'] =
        itemModifyOutputs.map((v) => v.toJson()).toList();
    return map;
  }
}
