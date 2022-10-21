import 'package:fixnum/fixnum.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import '../generated/pylons/item.pb.dart' as generated;

class Item {
  final generated.Item _native;

  Item(this._native);

  static Future<Item> fetch (String id, String? cookbook) async {
    if (cookbook == null) {
      if (Cookbook.current == null) {
        throw Exception('Load a cookbook before calling Item.fetch');
      }
      cookbook = Cookbook.current!.getId();
    }
    var ll = await PylonsWallet.instance.getItemById(cookbookId: cookbook, itemId: id);
    if (ll.success) {
      return Item(ll.data!);
    } else {
      return Future.error(ll.error);
    }
  }

  String getCookbookId() {
    return _native.cookbookId;
  }

  String getId() {
    return _native.id;
  }

  String getRecipeId() {
    return _native.recipeId;
  }

  String getOwner() {
    return _native.owner;
  }

  bool isTradeable() {
    return _native.tradeable;
  }

  double getTradePercentage() {
    // TODO: check if this is right
    return double.parse(_native.tradePercentage);
  }

  Int64 getLastUpdate() {
    // TODO: all of these should have some functionality to turn this into a datetime.
    // block height is godawful. encapsulating this sort of data in something useful
    // should be the big upside of hiding the generated types like this.
    // but that's all contingent on being able to get a real date/time from block height
    // somehow...
    return _native.lastUpdate;
  }

  Int64 getCreatedAt() {
    return _native.createdAt;
  }

  Int64 getUpdatedAt() {
    return _native.updatedAt;
  }

  Int64 getNodeVersion() {
    return _native.nodeVersion;
  }

  double? getDouble(String key) {
    var found;
    try {
      found = _native.doubles.firstWhere((element) => element.key == key);
    } on StateError {
      found = null;
    }
    return found;
  }

  Int64? getInt(String key) {
    var found;
    try {
      found = _native.longs.firstWhere((element) => element.key == key);
    } on StateError {
      found = null;
    }
    return found;
  }

  String? getString(String key) {
    var found;
    try {
      found = _native.strings.firstWhere((element) => element.key == key);
    } on StateError {
      found = null;
    }
    if (found == null) {
      try {
        found = _native.mutableStrings.firstWhere((element) => element.key == key);
      } on StateError {
        // swallow, it's already null
      }
    }
    return found;
  }
}