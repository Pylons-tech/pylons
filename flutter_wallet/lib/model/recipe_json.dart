import 'package:pylons_wallet/model/coininputs_json.dart';
import 'package:pylons_wallet/model/entries_json.dart';
import 'package:pylons_wallet/model/outputs_json.dart';
import 'package:pylons_wallet/model/strings_json.dart';

class RecipeJson {
  late Recipe recipe;

  RecipeJson({required this.recipe});

  RecipeJson.fromJson(Map<String, dynamic> json) {
    recipe = Recipe.fromJson(json['Recipe'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Recipe'] = recipe.toJson();
    return map;
  }
}

/// Test Recipe Format
/// cookbookID : ""
/// ID : ""
/// nodeVersion : ""
/// name : ""
/// description : ""
/// version : "
/// coinInputs : [{"coins":[{"denom":"","amount":""}]}]
/// itemInputs : []
/// entries : {"coinOutputs":[],"itemOutputs":[{"ID":"","doubles":[{"key":"","rate":"","weightRanges":[{"lower":"","upper":"","weight":"1"}],"program":"1"}],"longs":[{"key":"Quantity","rate":"0.000000000000000001","weightRanges":[{"lower":"23","upper":"23","weight":"1"}],"program":"1"},{"key":"Width","rate":"0.000000000000000001","weightRanges":[{"lower":"1920","upper":"1920","weight":"1"}],"program":""},{"key":"Height","rate":"0.000000000000000001","weightRanges":[{"lower":"1288","upper":"1288","weight":"1"}],"program":"1"}],"strings":[{"key":"Name","rate":"0.000000000000000001","value":"title title","program":""},{"key":"NFT_URL","rate":"0.000000000000000001","value":"https://www.imagesource.com/wp-content/uploads/2019/06/Rio.jpg","program":""},{"key":"Description","rate":"0.000000000000000001","value":"aaaaaaaaassasssssssssss\n","program":""},{"key":"Currency","rate":"0.000000000000000001","value":"pylon","program":""},{"key":"Price","rate":"0.000000000000000001","value":"12","program":"1"}],"mutableStrings":[],"transferFee":[],"tradePercentage":"0.000000000000000001","quantity":"23","amountMinted":"2","tradeable":true}],"itemModifyOutputs":[]}
/// outputs : [{"entryIDs":[""],"weight":""}]
/// blockInterval : ""
/// enabled : true
/// extraInfo : "\"\""

class Recipe {
  late String cookbookID;
  late String id;
  late String nodeVersion;
  late String name;
  late String description;
  late String version;
  late List<CoinInputs> coinInputs;
  late List<dynamic> itemInputs;
  late Entries entries;
  late List<Outputs> outputs;
  late String blockInterval;
  late bool enabled;
  late String extraInfo;

  Recipe({
    required this.cookbookID,
    required this.id,
    required this.nodeVersion,
    required this.name,
    required this.description,
    required this.version,
    required this.coinInputs,
    required this.itemInputs,
    required this.entries,
    required this.outputs,
    required this.blockInterval,
    required this.enabled,
    required this.extraInfo,
  });

  Recipe.fromJson(Map<String, dynamic> json) {
    cookbookID = json['cookbookID'] as String;
    id = json['ID'] as String;
    nodeVersion = json['nodeVersion'] as String;
    name = json['name'] as String;
    description = json['description'] as String;
    version = json['version'] as String;
    if (json['coinInputs'] != null) {
      coinInputs = [];
      for (final coinInputsJson in json['coinInputs']) {
        if (coinInputsJson is Map<String, dynamic>) {
          coinInputs.add(CoinInputs.fromJson(coinInputsJson));
        }
      }
    }

    if (json['itemInputs'] != null) {
      itemInputs = [];
      for (final itemInputsJson in json['itemInputs']) {
        if (itemInputsJson is Map<String, dynamic>) {}
      }
    }

    entries = Entries.fromJson(json['entries']);

    if (json['outputs'] != null) {
      outputs = [];
      for (final outputsJson in json['itemInputs']) {
        if (outputsJson is Map<String, dynamic>) {
          outputs.add(Outputs.fromJson(outputsJson));
        }
      }
    }

    blockInterval = json['blockInterval'] as String;
    enabled = json['enabled'] as bool;
    extraInfo = json['extraInfo'] as String;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cookbookID'] = cookbookID;
    map['ID'] = id;
    map['nodeVersion'] = nodeVersion;
    map['name'] = name;
    map['description'] = description;
    map['version'] = version;
    map['coinInputs'] = coinInputs.map((v) => v.toJson()).toList();
    map['itemInputs'] = itemInputs.map((v) => v.toJson()).toList();
    map['entries'] = entries.toJson();
    map['outputs'] = outputs.map((v) => v.toJson()).toList();
    map['blockInterval'] = blockInterval;
    map['enabled'] = enabled;
    map['extraInfo'] = extraInfo;
    return map;
  }
}

extension RecipeValues on RecipeJson {
  String get name => recipe.entries.itemOutputs.first.strings
      .firstWhere((strKeyVal) => strKeyVal.key == "Name",
          orElse: () => Strings(key: "", value: "", program: ""))
      .value;

  String get nftUrl => recipe.entries.itemOutputs.first.strings
      .firstWhere((strKeyVal) => strKeyVal.key == "NFT_URL",
          orElse: () => Strings(key: "", value: "", program: ""))
      .value;

  String get description => recipe.entries.itemOutputs.first.strings
      .firstWhere((strKeyVal) => strKeyVal.key == "Description",
          orElse: () => Strings(key: "", value: "", program: ""))
      .value;

  String get currency => recipe.entries.itemOutputs.first.strings
      .firstWhere((strKeyVal) => strKeyVal.key == "Currency",
          orElse: () => Strings(key: "", value: "", program: ""))
      .value;

  String get price => recipe.entries.itemOutputs.first.strings
      .firstWhere((strKeyVal) => strKeyVal.key == "Price",
          orElse: () => Strings(key: "", value: "", program: ""))
      .value;

  String get creator => recipe.entries.itemOutputs.first.strings
      .firstWhere((strKeyVal) => strKeyVal.key == "Creator",
          orElse: () => Strings(key: "", value: "", program: ""))
      .value;

  String get appType => recipe.entries.itemOutputs.first.strings
      .firstWhere((strKeyVal) => strKeyVal.key == "App_Type",
          orElse: () => Strings(key: "", value: "", program: ""))
      .value;

  String get width => recipe.entries.itemOutputs.first.longs
      .firstWhere((longKeyVal) => longKeyVal.key == "Width")
      .weightRanges
      .first
      .upper;

  String get height => recipe.entries.itemOutputs.first.longs
      .firstWhere((longKeyVal) => longKeyVal.key == "Height")
      .weightRanges
      .first
      .upper;

  String get quantity => recipe.entries.itemOutputs.first.quantity;

  String get amountMinted => recipe.entries.itemOutputs.first.amountMinted;

  String get tradePercentage =>
      recipe.entries.itemOutputs.first.tradePercentage;

  List<String> get itemIDs =>
      recipe.entries.itemOutputs.map((itemOutput) => itemOutput.id).toList();
}
