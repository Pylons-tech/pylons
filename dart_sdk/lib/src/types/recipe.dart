import 'package:fixnum/fixnum.dart';

import '../../pylons_sdk.dart';
import '../generated/pylons/item.pb.dart' as generated;
import '../generated/pylons/payment_info.pb.dart' as generated;
import '../generated/pylons/recipe.pb.dart' as generated;

const _PRECISION = 10;

class Recipe {
  final generated.Recipe _native;

  Recipe(this._native);

  static Future<Recipe?> get (String id, {String? cookbook}) async {
    final String cb;
    if (Cookbook.current == null && cookbook == null) {
      throw Exception('Must set cookbook before trying to fetch a recipe');
    }
    if (cookbook != null) {
      cb = cookbook;
    } else {
      cb = Cookbook.current!.getId();
    }
    final ll = await PylonsWallet.instance.getRecipe(cb, id);
    if (ll.success) {
      return Recipe(ll.data!);
    } else {
      return null;
    }
  }

  Future<Execution> executeWith (List<Item> inputs, {int CoinInputIndex = 0, List<generated.PaymentInfo>Function()? paymentInfoGen} ) async {
    var ids = <String>[];
    var infos = <generated.PaymentInfo>[];
    if (paymentInfoGen != null) infos = paymentInfoGen();

    inputs.forEach((item) {
      ids.add(item.getId());
    });
    // Pass this through to the low-level API
    var lowLevel = await PylonsWallet.instance.txExecuteRecipe(
        cookbookId: _native.cookbookId,
        recipeName: _native.name,
        itemIds: List.unmodifiable(ids),
        coinInputIndex: 0,
        paymentInfo: List.unmodifiable(infos));
    if (lowLevel.success) {
      return Execution(lowLevel.data!);
    } else {
      return Future.error(lowLevel.error);
    }
  }

  String getCookbookId() {
    return _native.cookbookId;
  }

  String getId() {
    return _native.id;
  }

  Int64 getNodeVersion() {
    return _native.nodeVersion;
  }

  String getName() {
    return _native.name;
  }

  String getDescription() {
    return _native.name;
  }

  String getVersion() {
    return _native.version;
  }

  String getExtraInfo() {
    return _native.extraInfo;
  }

  bool isEnabled() {
    return _native.enabled;
  }

  Int64 getCreatedAt() {
    return _native.createdAt;
  }

  Int64 getUpdatedAt() {
    return _native.updatedAt;
  }

  Map<String, Int64> getCoinInputs() {
    final ll = _native.coinInputs;
    final map = <String, Int64>{};
    ll.forEach((element) {
      for (var coin in element.coins) {
        map[coin.denom] = Int64.parseInt(coin.amount);
      }
    });
    return Map.unmodifiable(map);
  }

  List<ItemInput> getItemInputs() {
    var ls = <ItemInput>[];
    _native.itemInputs.forEach((element) {ls.add(ItemInput(element));});
    return List.unmodifiable(ls);
  }

  OutputSet getOutput() {
    return OutputSet(_native.entries, _native.outputs);
  }
}

class WeightedOutput {
  final generated.WeightedOutputs _native;

  WeightedOutput(this._native);

  Int64 getWeight() {
    return _native.weight;
  }

  List<String> getEntryIds() {
    return _native.entryIds;
  }
}

class OutputSet {
  final generated.EntriesList _nativeEntries;
  final List<generated.WeightedOutputs> _nativeOutputs;

  OutputSet(this._nativeEntries, this._nativeOutputs);

  List<WeightedOutput> getWeightedOutputs() {
    var ls = <WeightedOutput>[];
    _nativeOutputs.forEach((element) {ls.add(WeightedOutput(element));});
    return List.unmodifiable(ls);
  }

  List<ItemOutput> getItemOutputs() {
    var ls = <ItemOutput>[];
    _nativeEntries.itemOutputs.forEach((element) {ls.add(ItemOutput.fromItemOutput(element));});
    _nativeEntries.itemModifyOutputs.forEach((element) {ls.add(ItemOutput.fromItemModifyOutput(element));});
    return List.unmodifiable(ls);
  }

  List<CoinOutput> getCoinOutputs() {
    var ls = <CoinOutput>[];
    _nativeEntries.coinOutputs.forEach((element) {ls.add(CoinOutput(element));});
    return List.unmodifiable(ls);
  }
}

class CoinOutput {
  final generated.CoinOutput _native;

  CoinOutput(this._native);

  String getId() {
    return _native.id;
  }

  String getProgram() {
    return _native.program;
  }

  String getDenom() {
    return _native.coin.denom;
  }
}

class ItemOutput {
  final generated.ItemOutput? _native;
  final generated.ItemModifyOutput? _nativeModify;
  final bool modify;

  ItemOutput(this._native, this._nativeModify, this.modify);

  ItemOutput.fromItemOutput (generated.ItemOutput n) : _native = n, _nativeModify = null, modify = false;
  ItemOutput.fromItemModifyOutput (generated.ItemModifyOutput n) : _native = null, _nativeModify = n, modify = true;

  String getId() {
    if (modify) {
      return _nativeModify!.id;
    } else {
      return _native!.id;
    }
  }

  bool isTradeable() {
    if (modify) {
      return _nativeModify!.tradeable;
    } else {
      return _native!.tradeable;
    }
  }

  double getTradePercentage() {
    if (modify) {
      return double.parse(_nativeModify!.tradePercentage) * _PRECISION;
    } else {
      return double.parse(_native!.tradePercentage) * _PRECISION;
    }
  }

  Int64 getAmountMinted() {
    if (modify) {
      return _nativeModify!.amountMinted;
    } else {
      return _native!.amountMinted;
    }
  }

  Int64 getQuantity() {
    if (modify) {
      return _nativeModify!.quantity;
    } else {
      return _native!.quantity;
    }
  }

  Map<String, Int64> getTransferFee() {
    var map = <String, Int64>{};
    if (modify) {
      _nativeModify!.transferFee.forEach((element) {map[element.denom] = Int64.parseInt(element.amount); });
    } else {
      _native!.transferFee.forEach((element) {map[element.denom] = Int64.parseInt(element.amount); });
    }
    return Map.unmodifiable(map);
  }

  DoubleOutput? getDouble(String name) {
    try {
      if (modify) {
        return DoubleOutput(_nativeModify!.doubles.firstWhere((element) => element.key == name));
      } else {
        return DoubleOutput(_native!.doubles.firstWhere((element) => element.key == name));
      }
    } on StateError {
      return null;
    }
  }

  List<DoubleOutput> getDoubles() {
    var ls = <DoubleOutput>[];
    if (modify) {
      _nativeModify!.doubles.forEach((element) {ls.add(DoubleOutput(element));});
    } else {
      _native!.doubles.forEach((element) {ls.add(DoubleOutput(element));});
    }
    return List.unmodifiable(ls);
  }

  LongOutput? getLong(String name) {
    try {
      if (modify) {
        return LongOutput(_nativeModify!.longs.firstWhere((element) => element.key == name));
      } else {
        return LongOutput(_native!.longs.firstWhere((element) => element.key == name));
      }
    } on StateError {
      return null;
    }
  }

  List<LongOutput> getLongs() {
    var ls = <LongOutput>[];
    if (modify) {
      _nativeModify!.longs.forEach((element) {ls.add(LongOutput(element));});
    } else {
      _native!.longs.forEach((element) {ls.add(LongOutput(element));});
    }
    return List.unmodifiable(ls);
  }

  StringOutput? getString(String name) {
    try {
      if (modify) {
        return StringOutput.fromParam(_nativeModify!.strings.firstWhere((element) => element.key == name));
      } else {
        return StringOutput.fromParam(_native!.strings.firstWhere((element) => element.key == name));
      }
    } on StateError {
      try {
        if (modify) {
          return StringOutput.fromKV(_nativeModify!.mutableStrings.firstWhere((element) => element.key == name));
        } else {
          return StringOutput.fromKV(_native!.mutableStrings.firstWhere((element) => element.key == name));
        }
      } on StateError {
        return null;
      }
    }
  }

  List<StringOutput> getStrings() {
    var ls = <StringOutput>[];
    if (modify) {
      _nativeModify!.strings.forEach((element) {ls.add(StringOutput.fromParam(element));});
      _nativeModify!.mutableStrings.forEach((element) {ls.add(StringOutput.fromKV(element));});
    } else {
      _native!.strings.forEach((element) {ls.add(StringOutput.fromParam(element));});
      _native!.mutableStrings.forEach((element) {ls.add(StringOutput.fromKV(element));});
    }
    return List.unmodifiable(ls);
  }

  String getItemInputRef() {
    if (modify) {
      return _nativeModify!.itemInputRef;
    } else {
      throw Exception('Not an ItemModifyOutput');
    }
  }
}

class ItemInput {
  final generated.ItemInput _native;

  ItemInput(this._native);

  String getId() {
    return _native.id;
  }

  DoubleInput? getDouble(String name) {
    try {
      return DoubleInput(_native.doubles.firstWhere((element) => element.key == name));
    } on StateError {
      return null;
    }
  }

  List<DoubleInput> getDoubles() {
    var ls = <DoubleInput>[];
    _native.doubles.forEach((element) {ls.add(DoubleInput(element));});
    return List.unmodifiable(ls);
  }

  LongInput? getLong(String name) {
    try {
      return LongInput(_native.longs.firstWhere((element) => element.key == name));
    } on StateError {
      return null;
    }
  }

  List<LongInput> getLongs() {
    var ls = <LongInput>[];
    _native.longs.forEach((element) {ls.add(LongInput(element));});
    return List.unmodifiable(ls);
  }

  StringInput? getString(String name) {
    try {
      return StringInput(_native.strings.firstWhere((element) => element.key == name));
    } on StateError {
      return null;
    }
  }

  List<StringInput> getStrings() {
    var ls = <StringInput>[];
    _native.strings.forEach((element) {ls.add(StringInput(element));});
    return List.unmodifiable(ls);
  }
}

class DoubleInput {
  final generated.DoubleInputParam _native;

  DoubleInput(this._native);

  String getKey() {
    return _native.key;
  }

  double getMin () {
    return double.parse(_native.minValue) / _PRECISION;
  }

  double getMax () {
    return double.parse(_native.minValue) / _PRECISION;
  }
}

class DoubleOutput {
  final generated.DoubleParam _native;

  DoubleOutput(this._native);

  String getKey() {
    return _native.key;
  }

  String getProgram() {
    return _native.program;
  }

  List<DoubleWeightRange> getWeightRanges() {
    var ls = <DoubleWeightRange>[];
    _native.weightRanges.forEach((element) {
      ls.add(DoubleWeightRange(element));
    });
    return List.unmodifiable(ls);
  }
}

class DoubleWeightRange {
  final generated.DoubleWeightRange _native;

  DoubleWeightRange(this._native);

  Int64 getWeight() {
    return _native.weight;
  }

  double getMin () {
    return double.parse(_native.lower) / _PRECISION;
  }

  double getMax () {
    return double.parse(_native.upper) / _PRECISION;
  }
}

class LongInput {
  final generated.LongInputParam _native;

  LongInput(this._native);

  String getKey() {
    return _native.key;
  }

  Int64 getMin () {
    return _native.minValue;
  }

  Int64 getMax () {
    return _native.maxValue;
  }
}

class LongOutput {
  final generated.LongParam _native;

  LongOutput(this._native);

  String getKey() {
    return _native.key;
  }

  String getProgram() {
    return _native.program;
  }

  List<LongWeightRange> getWeightRanges() {
    var ls = <LongWeightRange>[];
    _native.weightRanges.forEach((element) {
      ls.add(LongWeightRange(element));
    });
    return List.unmodifiable(ls);
  }
}

class LongWeightRange {
  final generated.IntWeightRange _native;

  LongWeightRange(this._native);

  Int64 getWeight() {
    return _native.weight;
  }

  Int64 getMin () {
    return _native.lower;
  }

  Int64 getMax () {
    return _native.upper;
  }
}

class StringInput {
  final generated.StringInputParam _native;

  StringInput(this._native);

  String getKey() {
    return _native.key;
  }

  String getValue () {
    return _native.value;
  }
}

class StringOutput {
  final generated.StringParam? _native;
  final generated.StringKeyValue? _nativeMutable;
  final bool mutable;

  StringOutput(this._native, this._nativeMutable, this.mutable);

  StringOutput.fromParam (generated.StringParam n) : _native = n, _nativeMutable = null, mutable = false;
  StringOutput.fromKV (generated.StringKeyValue n) : _native = null, _nativeMutable = n, mutable = true;

  String getKey() {
    if (mutable) {
      return _nativeMutable!.key;
    } else {
      return _native!.key;
    }
  }

  String getProgram() {
    if (mutable) {
      // no program on this field
      return _nativeMutable!.value;
    } else {
      return _native!.value;
    }
  }

  String getValue () {
    if (mutable) {
      return _nativeMutable!.value;
    } else {
      return _native!.value;
    }
  }
}