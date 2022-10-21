import 'package:dartz/dartz_unsafe.dart';
import 'package:fixnum/fixnum.dart';

import '../generated/pylons/payment_info.pb.dart';
import '../generated/pylons/recipe.pb.dart' as generated;
import '../pylons_wallet.dart';
import 'item.dart';
import 'execution.dart';

const _PRECISION = 10;

class Recipe {
  final generated.Recipe _native;

  Recipe(this._native);

  Future<Execution> executeWith (List<Item> inputs, {int CoinInputIndex = 0, List<PaymentInfo>Function()? paymentInfoGen} ) async {
    var ids = <String>[];
    var infos = <PaymentInfo>[];
    if (paymentInfoGen != null) infos = paymentInfoGen();

    inputs.forEach((item) {
      ids.add(item.getId());
    });
    // Pass this through to the low-level API
    var lowLevel = await PylonsWallet.instance.txExecuteRecipe(
        cookbookId: _native.cookbookId,
        recipeName: _native.name,
        itemIds: ids,
        coinInputIndex: 0,
        paymentInfo: infos);
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
  // todo: entries
  // todo: outputs

  Map<String, int> getCoinInputs() {
    final ll = _native.coinInputs;
    final map = <String, int>{};
    ll.forEach((element) {
      for (var coin in element.coins) {
        map[coin.denom] = int.parse(coin.amount);
      }
    })
    return map;
  }

  List<ItemInput> getItemInputs() {
    var ls = <ItemInput>[];
    _native.itemInputs.forEach((element) {ls.add(ItemInput(element));});
    return ls;
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
    return ls;
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
    return ls;
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
    return ls;
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