import 'package:fixnum/fixnum.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import '../generated/pylons/execution.pb.dart' as generated;
import '../generated/pylons/item.pb.dart' as generated;

class Item {
  final generated.Item? _native;
  // if from itemrecord: missing a bunch of fields, keep that in mind
  final generated.ItemRecord? _nativeRecord;
  final bool _complete;

  Item(this._native, this._nativeRecord, this._complete);

  Item.fromItem(generated.Item n) : _native = n, _nativeRecord = null, _complete = true;
  Item.fromRecord(generated.ItemRecord n) : _native = null, _nativeRecord = n, _complete = false;

  static Future<Item> fetch (String id, String? cookbook) async {
    if (cookbook == null) {
      if (Cookbook.current == null) {
        throw Exception('Load a cookbook before calling Item.fetch');
      }
      cookbook = Cookbook.current!.getId();
    }
    var ll = await PylonsWallet.instance.getItemById(cookbookId: cookbook, itemId: id);
    if (ll.success) {
      return Item.fromItem(ll.data!);
    } else {
      return Future.error(ll.error);
    }
  }

  String getCookbookId() {
    if (_complete) {
      return _native!.cookbookId;
    } else {
      throw UnsupportedError('Cannot retrieve this field from ItemRecord - call Item.fetch() with the provided ID if needed');
    }
  }

  String getId() {
    if (_complete) {
      return _native!.id;
    } else {
      return _nativeRecord!.id;
    }
  }

  String getRecipeId() {
    if (_complete) {
      return _native!.recipeId;
    } else {
      throw UnsupportedError('Cannot retrieve this field from ItemRecord - call Item.fetch() with the provided ID if needed');
    }
  }

  String getOwner() {
    if (_complete) {
      return _native!.owner;
    } else {
      throw UnsupportedError('Cannot retrieve this field from ItemRecord - call Item.fetch() with the provided ID if needed');
    }
  }

  bool isTradeable() {
    if (_complete) {
      return _native!.tradeable;
    } else {
      throw UnsupportedError('Cannot retrieve this field from ItemRecord - call Item.fetch() with the provided ID if needed');
    }
  }

  double getTradePercentage() {
    if (_complete) {
      // TODO: check if this is right
      return double.parse(_native!.tradePercentage);
    } else {
      throw UnsupportedError('Cannot retrieve this field from ItemRecord - call Item.fetch() with the provided ID if needed');
    }
  }

  Int64 getLastUpdate() {
    if (_complete) {
      // TODO: all of these should have some functionality to turn this into a datetime.
      // block height is godawful. encapsulating this sort of data in something useful
      // should be the big upside of hiding the generated types like this.
      // but that's all contingent on being able to get a real date/time from block height
      // somehow...
      return _native!.lastUpdate;
    } else {
      throw UnsupportedError('Cannot retrieve this field from ItemRecord - call Item.fetch() with the provided ID if needed');
    }
  }

  Int64 getCreatedAt() {
    if (_complete) {
      return _native!.createdAt;
    } else {
      throw UnsupportedError('Cannot retrieve this field from ItemRecord - call Item.fetch() with the provided ID if needed');
    }
  }

  Int64 getUpdatedAt() {
    if (_complete) {
      return _native!.updatedAt;
    } else {
      throw UnsupportedError('Cannot retrieve this field from ItemRecord - call Item.fetch() with the provided ID if needed');
    }
  }

  Int64 getNodeVersion() {
    if (_complete) {
      return _native!.nodeVersion;
    } else {
      throw UnsupportedError('Cannot retrieve this field from ItemRecord - call Item.fetch() with the provided ID if needed');
    }
  }

  double? getDouble(String key) {
    var found;
    try {
      if (_complete) {
        found = _native!.doubles.firstWhere((element) => element.key == key);
      } else {
        found = _nativeRecord!.doubles.firstWhere((element) => element.key == key);
      }
    } on StateError {
      found = null;
    }
    return found;
  }

  Int64? getInt(String key) {
    var found;
    try {
      if (_complete) {
        found = _native!.longs.firstWhere((element) => element.key == key);
      } else {
        found = _nativeRecord!.longs.firstWhere((element) => element.key == key);
      }
    } on StateError {
      found = null;
    }
    return found;
  }

  String? getString(String key) {
    var found;
    try {
      if (_complete) {
        found = _native!.strings.firstWhere((element) => element.key == key);
      } else {
        found = _nativeRecord!.strings.firstWhere((element) => element.key == key);
      }
    } on StateError {
      found = null;
    }
    if (found == null) {
      try {
        if (_complete) {
          found = _native!.mutableStrings.firstWhere((element) => element.key == key);
        }
      } on StateError {
        // swallow, it's already null
      }
    }
    return found;
  }
}