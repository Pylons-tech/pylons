import 'package:fixnum/fixnum.dart';

import '../../pylons_sdk.dart';
import '../generated/pylons/item.pb.dart' as generated;
import '../generated/pylons/payment_info.pb.dart' as generated;
import '../generated/pylons/recipe.pb.dart' as generated;

/// Wrapper object for a recipe.
/// These can be retrieved from a number of queries and operations,
/// or created using an id alone. In the latter case, the recipe is considered
/// partial, and does not support any operations other than executing it.
///
/// Note that partial recipes are not guaranteed to exist on chain;
/// make sure your ID is correct when using them. However, since partial
/// recipes do not need to be retrieved before use, they enable a smoother
/// user experience.
class Recipe {
  final generated.Recipe? _native;
  final String? _forcedId;

  Recipe(this._native, this._forcedId);

  Recipe.fromId(String n)
      : _native = null,
        _forcedId = n;
  Recipe.fromRecipe(generated.Recipe n)
      : _native = n,
        _forcedId = null;

  /// Retrieves the current state of a recipe from the chain.
  /// If cookbook is specified manually, you can override the loaded cookbook
  /// or query a recipe before loading a cookbook; otherwise, the recipe
  /// will be retrieved for the loaded cookbook.
  static Future<Recipe?> get(String id, {String? cookbook}) async {
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
      return Recipe.fromRecipe(ll.data!);
    } else {
      return null;
    }
  }

  /// Produces a partial recipe for the provided ID and the current cookbook.
  static Recipe let(String id) {
    if (Cookbook.current == null) {
      throw Exception('Must set cookbook before trying to fetch a recipe');
    }
    return Recipe.fromId(id);
  }

  // todo: document the optional parameters
  /// Executes the provided recipe using the provided profile and item inputs, and returns an execution.
  /// If the execution fails, returns an error instead.
  /// Because executions are currently not working, all you really get out of this is "the transaction
  /// didn't fail." If you need specific outputs after executing a recipe, you'll have to retrieve those
  /// from the user profile manually.
  ///
  /// This is obviously not an ideal state of affairs, and will be fixed ASAP.
  Future<Execution> executeWith(Profile prf, List<Item> inputs,
      {int CoinInputIndex = 0,
      List<generated.PaymentInfo> Function()? paymentInfoGen}) async {
    var ids = <String>[];
    var infos = <generated.PaymentInfo>[];
    if (paymentInfoGen != null) infos = paymentInfoGen();

    inputs.forEach((item) {
      ids.add(item.getId());
    });
    // Pass this through to the low-level API
    String cb;
    String name;
    if (_native != null) {
      cb = _native!.cookbookId;
      name = _native!.name;
    } else {
      cb = Cookbook.current!.getId();
      name = _forcedId!;
    }
    var lowLevel = await PylonsWallet.instance.txExecuteRecipe(
        cookbookId: cb,
        recipeName: name,
        itemIds: List.unmodifiable(ids),
        coinInputIndex: 0,
        paymentInfo: List.unmodifiable(infos),
        sender: prf.address,
        requestResponse: true);
    if (lowLevel.error == '') {
      return Execution(lowLevel.data!);
    } else {
      print(lowLevel.error);
      return Future.error(lowLevel.error);
    }
  }

  /// Retrieves the ID of the recipe's associated cookbook.
  ///
  /// Not available on partial recipes.
  String getCookbookId() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    return _native!.cookbookId;
  }

  /// Retrieves the ID of the recipe.
  ///
  /// Not available on partial recipes.
  String getId() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    return _native!.id;
  }

  /// Retrieves the node version of this recipe.
  /// Since all recipes are retrieved from the chain,
  /// this should generally just be the current version;
  /// don't worry about it.
  ///
  /// Not available on partial recipes.
  Int64 getNodeVersion() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    return _native!.nodeVersion;
  }

  /// Retrieves the human-readable name of the recipe.
  ///
  /// Not available on partial recipes.
  String getName() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    return _native!.name;
  }

  /// Retrieves the human-readable description of the recipe.
  ///
  /// Not available on partial recipes.
  String getDescription() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    return _native!.description;
  }

  /// Retrieves the version of the recipe.
  /// This is a SemVer string.
  ///
  /// Not available on partial recipes.
  String getVersion() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    return _native!.version;
  }

  /// Retrieves the recipe's extra info field.
  /// This can be used for additional human-readable details,
  /// or for metadata for tools that work directly with recipes.
  ///
  /// Not available on partial recipes.
  String getExtraInfo() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    return _native!.extraInfo;
  }

  /// Is the recipe enabled?
  ///
  /// Not available on partial recipes.
  bool isEnabled() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    return _native!.enabled;
  }

  /// Retrieves the block height as of this recipe's creation.
  ///
  /// Not available on partial recipes.
  Int64 getCreatedAt() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    return _native!.createdAt;
  }

  /// Retrieves the block height as of this recipe's last update.
  ///
  /// Not available on partial recipes.
  Int64 getUpdatedAt() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    return _native!.updatedAt;
  }

  /// Retrieves a map of all coins consumed upon execution of this recipe.
  /// If the user's profile doesn't have enough of any of these coins,
  /// the execution will fail.
  ///
  /// Not available on partial recipes.
  Map<String, Int64> getCoinInputs() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    final ll = _native!.coinInputs;
    final map = <String, Int64>{};
    ll.forEach((element) {
      for (var coin in element.coins) {
        map[coin.denom] = Int64.parseInt(coin.amount);
      }
    });
    return Map.unmodifiable(map);
  }

  /// Retrieves a list of all item input patterns contained by this recipe.
  /// If the items provided during execution do not contain matches for each of these patterns,
  /// the execution will fail.
  ///
  /// Not available on partial recipes.
  List<ItemInput> getItemInputs() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    var ls = <ItemInput>[];
    _native!.itemInputs.forEach((element) {
      ls.add(ItemInput(element));
    });
    return List.unmodifiable(ls);
  }

  /// Retrieves all output data for this recipe.
  /// See OutputSet and its child elements for more details.
  ///
  /// Not available on partial recipes.
  OutputSet getOutput() {
    if (_native == null) {
      throw UnsupportedError(
          'Cannot get recipe fields from a partial recipe - use Recipe.get() if you need that data');
    }
    return OutputSet(_native!.entries, _native!.outputs);
  }
}

/// Thin wrapper for an output list for a recipe.
/// This is a structure used to produce probabilistic outputs
/// for recipes.
class WeightedOutput {
  final generated.WeightedOutputs _native;

  WeightedOutput(this._native);

  /// The weight of this output list. More weight = more likely.
  ///
  /// Example:
  /// If a recipe contains two output lists of weight 1 and one of
  /// weight 3, then the probabilities of each list being used
  /// are respectively 1/5, 1/5, and 3/5.
  Int64 getWeight() {
    return _native.weight;
  }

  /// The entry IDs associated with this output list.
  List<String> getEntryIds() {
    return _native.entryIds;
  }
}

/// Thin wrapper for the total output set of a recipe.
/// This is kinda complex - it contains both entries, which describe the
/// possible actual item/coin outputs of the recipe, and weighted output
/// lists, which describe the probabilities of those outputs being generated.
///
/// A useful way to think about this is - an entry is a goodie bag. When
/// you execute the recipe, it spins a wheel to determine which bag you get.
/// The output list describes the shape of that wheel - which stops are
/// associated with which bag, and how large those stops are relative to
/// each other.
class OutputSet {
  final generated.EntriesList _nativeEntries;
  final List<generated.WeightedOutputs> _nativeOutputs;

  OutputSet(this._nativeEntries, this._nativeOutputs);

  /// Retrieves the output lists.
  List<WeightedOutput> getWeightedOutputs() {
    var ls = <WeightedOutput>[];
    _nativeOutputs.forEach((element) {
      ls.add(WeightedOutput(element));
    });
    return List.unmodifiable(ls);
  }

  /// Retrieves all possible item outputs.
  List<ItemOutput> getItemOutputs() {
    var ls = <ItemOutput>[];
    _nativeEntries.itemOutputs.forEach((element) {
      ls.add(ItemOutput.fromItemOutput(element));
    });
    _nativeEntries.itemModifyOutputs.forEach((element) {
      ls.add(ItemOutput.fromItemModifyOutput(element));
    });
    return List.unmodifiable(ls);
  }

  /// Retrieves all possible coin outputs.
  List<CoinOutput> getCoinOutputs() {
    var ls = <CoinOutput>[];
    _nativeEntries.coinOutputs.forEach((element) {
      ls.add(CoinOutput(element));
    });
    return List.unmodifiable(ls);
  }
}

/// Thin wrapper for a possible coin output.
class CoinOutput {
  final generated.CoinOutput _native;

  CoinOutput(this._native);

  /// The ID of this coin output, as used in the weighted output lists.
  String getId() {
    return _native.id;
  }

  /// A CEL expression that will determine the number of coins output.
  /// In the simplest case, this can just be a number, and exactly that
  /// many coins will be output.
  String getProgram() {
    return _native.program;
  }

  /// The denomination of coin to be output.
  String getDenom() {
    return _native.coin.denom;
  }
}

/// Thin wrapper for a possible item output.
///
/// Note that many fields on an item output map *directly* to corresponding
/// fields on an item.
class ItemOutput {
  final generated.ItemOutput? _native;
  final generated.ItemModifyOutput? _nativeModify;

  /// If true, this output applies a transformation to a specified input item, as opposed
  /// to generating a new item.
  final bool modify;

  ItemOutput(this._native, this._nativeModify, this.modify);

  ItemOutput.fromItemOutput(generated.ItemOutput n)
      : _native = n,
        _nativeModify = null,
        modify = false;
  ItemOutput.fromItemModifyOutput(generated.ItemModifyOutput n)
      : _native = null,
        _nativeModify = n,
        modify = true;

  /// The ID of this item output, as used in the weighted output lists.
  String getId() {
    if (modify) {
      return _nativeModify!.id;
    } else {
      return _native!.id;
    }
  }

  /// Can the item be transferred to other users?
  ///
  /// See: Item.isTradeable
  bool isTradeable() {
    if (modify) {
      return _nativeModify!.tradeable;
    } else {
      return _native!.tradeable;
    }
  }

  /// To be documented; not generally significant to client applications.
  ///
  /// See: Item.getTradePercentage
  double getTradePercentage() {
    if (modify) {
      return DecString.doubleFromDecString(_nativeModify!.tradePercentage);
    } else {
      return DecString.doubleFromDecString(_native!.tradePercentage);
    }
  }

  /// How many of this item have been minted, to date?
  Int64 getAmountMinted() {
    if (modify) {
      return _nativeModify!.amountMinted;
    } else {
      return _native!.amountMinted;
    }
  }

  /// How many of this item can be minted, at most?
  /// If zero, infinite.
  Int64 getQuantity() {
    if (modify) {
      return _nativeModify!.quantity;
    } else {
      return _native!.quantity;
    }
  }

  /// To be documented; not generally significant to client applications.
  Map<String, Int64> getTransferFee() {
    var map = <String, Int64>{};
    if (modify) {
      _nativeModify!.transferFee.forEach((element) {
        map[element.denom] = Int64.parseInt(element.amount);
      });
    } else {
      _native!.transferFee.forEach((element) {
        map[element.denom] = Int64.parseInt(element.amount);
      });
    }
    return Map.unmodifiable(map);
  }

  /// Retrieves the double parameter output definition with the provided key.
  DoubleOutput? getDouble(String name) {
    try {
      if (modify) {
        return DoubleOutput(_nativeModify!.doubles
            .firstWhere((element) => element.key == name));
      } else {
        return DoubleOutput(
            _native!.doubles.firstWhere((element) => element.key == name));
      }
    } on StateError {
      return null;
    }
  }

  /// Retrieves all double parameter output definitions.
  List<DoubleOutput> getDoubles() {
    var ls = <DoubleOutput>[];
    if (modify) {
      _nativeModify!.doubles.forEach((element) {
        ls.add(DoubleOutput(element));
      });
    } else {
      _native!.doubles.forEach((element) {
        ls.add(DoubleOutput(element));
      });
    }
    return List.unmodifiable(ls);
  }

  /// Retrieves the Int64 parameter output definition with the provided key.
  LongOutput? getLong(String name) {
    try {
      if (modify) {
        return LongOutput(
            _nativeModify!.longs.firstWhere((element) => element.key == name));
      } else {
        return LongOutput(
            _native!.longs.firstWhere((element) => element.key == name));
      }
    } on StateError {
      return null;
    }
  }

  /// Retrieves all Int64 parameter output definitions.
  List<LongOutput> getLongs() {
    var ls = <LongOutput>[];
    if (modify) {
      _nativeModify!.longs.forEach((element) {
        ls.add(LongOutput(element));
      });
    } else {
      _native!.longs.forEach((element) {
        ls.add(LongOutput(element));
      });
    }
    return List.unmodifiable(ls);
  }

  /// Retrieves the string parameter output definition with the provided key.
  StringOutput? getString(String name) {
    try {
      if (modify) {
        return StringOutput.fromParam(_nativeModify!.strings
            .firstWhere((element) => element.key == name));
      } else {
        return StringOutput.fromParam(
            _native!.strings.firstWhere((element) => element.key == name));
      }
    } on StateError {
      try {
        if (modify) {
          return StringOutput.fromKV(_nativeModify!.mutableStrings
              .firstWhere((element) => element.key == name));
        } else {
          return StringOutput.fromKV(_native!.mutableStrings
              .firstWhere((element) => element.key == name));
        }
      } on StateError {
        return null;
      }
    }
  }

  /// Retrieves all string parameter output definitions.
  List<StringOutput> getStrings() {
    var ls = <StringOutput>[];
    if (modify) {
      _nativeModify!.strings.forEach((element) {
        ls.add(StringOutput.fromParam(element));
      });
      _nativeModify!.mutableStrings.forEach((element) {
        ls.add(StringOutput.fromKV(element));
      });
    } else {
      _native!.strings.forEach((element) {
        ls.add(StringOutput.fromParam(element));
      });
      _native!.mutableStrings.forEach((element) {
        ls.add(StringOutput.fromKV(element));
      });
    }
    return List.unmodifiable(ls);
  }

  /// Retrieves the ID of the input item this output is applied to, if this is an item-modifying output.
  String getItemInputRef() {
    if (modify) {
      return _nativeModify!.itemInputRef;
    } else {
      throw Exception('Not an ItemModifyOutput');
    }
  }
}

/// Thin wrapper for an item input pattern.
class ItemInput {
  final generated.ItemInput _native;

  ItemInput(this._native);

  /// Retrieves the ID of this input.
  String getId() {
    return _native.id;
  }

  /// Retrieves the double parameter input pattern with the provided key.
  DoubleInput? getDouble(String name) {
    try {
      return DoubleInput(
          _native.doubles.firstWhere((element) => element.key == name));
    } on StateError {
      return null;
    }
  }

  /// Retrieves all double parameter input patterns.
  List<DoubleInput> getDoubles() {
    var ls = <DoubleInput>[];
    _native.doubles.forEach((element) {
      ls.add(DoubleInput(element));
    });
    return List.unmodifiable(ls);
  }

  /// Retrieves the Int64 parameter input pattern with the provided key.
  LongInput? getLong(String name) {
    try {
      return LongInput(
          _native.longs.firstWhere((element) => element.key == name));
    } on StateError {
      return null;
    }
  }

  /// Retrieves all Int64 parameter input patterns.
  List<LongInput> getLongs() {
    var ls = <LongInput>[];
    _native.longs.forEach((element) {
      ls.add(LongInput(element));
    });
    return List.unmodifiable(ls);
  }

  /// Retrieves the string parameter input pattern with the provided key.
  StringInput? getString(String name) {
    try {
      return StringInput(
          _native.strings.firstWhere((element) => element.key == name));
    } on StateError {
      return null;
    }
  }

  /// Retrieves all string parameter input patterns.
  List<StringInput> getStrings() {
    var ls = <StringInput>[];
    _native.strings.forEach((element) {
      ls.add(StringInput(element));
    });
    return List.unmodifiable(ls);
  }
}

/// Thin wrapper for a double parameter input pattern.
/// Describes the potential values for a parameter on an item input.
class DoubleInput {
  final generated.DoubleInputParam _native;

  DoubleInput(this._native);

  /// The name of the parameter to match.
  String getKey() {
    return _native.key;
  }

  /// Minimum value of the parameter to match.
  double getMin() {
    return DecString.doubleFromDecString(_native.minValue);
  }

  /// Maximum value of the parameter to match.
  double getMax() {
    return DecString.doubleFromDecString(_native.maxValue);
  }
}

/// Thin wrapper for a double parameter output definition.
/// Describes the potential values for a parameter on an item output.
class DoubleOutput {
  final generated.DoubleParam _native;

  DoubleOutput(this._native);

  /// The name of the parameter.
  String getKey() {
    return _native.key;
  }

  /// A CEL expression that will determine the value of the parameter.
  /// In the simplest case, this can just be a number, which will be the
  /// value.
  String getProgram() {
    return _native.program;
  }

  /// List of weight ranges to use to generate the value of the parameter,
  /// if no program. The weighting here works similarly to the weight on
  /// output lists.
  List<DoubleWeightRange> getWeightRanges() {
    var ls = <DoubleWeightRange>[];
    _native.weightRanges.forEach((element) {
      ls.add(DoubleWeightRange(element));
    });
    return List.unmodifiable(ls);
  }
}

/// Thin wrapper for a weighted range that the value of a double parameter
/// could take.
class DoubleWeightRange {
  final generated.DoubleWeightRange _native;

  DoubleWeightRange(this._native);

  /// The weight associated with this range.
  Int64 getWeight() {
    return _native.weight;
  }

  /// Minimum value of the parameter.
  double getMin() {
    return DecString.doubleFromDecString(_native.lower);
  }

  /// Maximum value of the parameter.
  double getMax() {
    return DecString.doubleFromDecString(_native.upper);
  }
}

/// Thin wrapper for an Int64 parameter input pattern.
/// Describes the potential values for a parameter on an item input.
class LongInput {
  final generated.LongInputParam _native;

  LongInput(this._native);

  /// The name of the parameter to match.
  String getKey() {
    return _native.key;
  }

  /// Minimum value of the parameter to match.
  Int64 getMin() {
    return _native.minValue;
  }

  /// Maximum value of the parameter to match.
  Int64 getMax() {
    return _native.maxValue;
  }
}

/// Thin wrapper for an Int64 parameter output definition.
/// Describes the potential values for a parameter on an item output.
class LongOutput {
  final generated.LongParam _native;

  LongOutput(this._native);

  String getKey() {
    return _native.key;
  }

  /// A CEL expression that will determine the value of the parameter.
  /// In the simplest case, this can just be a number, which will be the
  /// value.
  String getProgram() {
    return _native.program;
  }

  /// List of weight ranges to use to generate the value of the parameter,
  /// if no program. The weighting here works similarly to the weight on
  /// output lists.
  List<LongWeightRange> getWeightRanges() {
    var ls = <LongWeightRange>[];
    _native.weightRanges.forEach((element) {
      ls.add(LongWeightRange(element));
    });
    return List.unmodifiable(ls);
  }
}

/// Thin wrapper for a weighted range that the value of a double parameter
/// could take.
class LongWeightRange {
  final generated.IntWeightRange _native;

  LongWeightRange(this._native);

  /// The weight associated with this range.
  Int64 getWeight() {
    return _native.weight;
  }

  /// Minimum value of the parameter to match.
  Int64 getMin() {
    return _native.lower;
  }

  /// Maximum value of the parameter to match.
  Int64 getMax() {
    return _native.upper;
  }
}

/// Thin wrapper for a string parameter input pattern.
/// Describes the potential values for a parameter on an item input.
class StringInput {
  final generated.StringInputParam _native;

  StringInput(this._native);

  /// The name of the parameter to match.
  String getKey() {
    return _native.key;
  }

  /// Exact value of the parameter to match.
  String getValue() {
    return _native.value;
  }
}

/// Thin wrapper for a string parameter output definition.
/// Describes the potential values for a parameter on an item output.
class StringOutput {
  final generated.StringParam? _native;
  final generated.StringKeyValue? _nativeMutable;
  final bool mutable;

  StringOutput(this._native, this._nativeMutable, this.mutable);

  StringOutput.fromParam(generated.StringParam n)
      : _native = n,
        _nativeMutable = null,
        mutable = false;
  StringOutput.fromKV(generated.StringKeyValue n)
      : _native = null,
        _nativeMutable = n,
        mutable = true;

  /// The name of the parameter.
  String getKey() {
    if (mutable) {
      return _nativeMutable!.key;
    } else {
      return _native!.key;
    }
  }

  /// A CEL expression that will determine the value of the parameter.
  String getProgram() {
    if (mutable) {
      // no program on this field
      return _nativeMutable!.value;
    } else {
      return _native!.value;
    }
  }

  /// Exact value of the parameter, if no program.
  String getValue() {
    if (mutable) {
      return _nativeMutable!.value;
    } else {
      return _native!.value;
    }
  }
}
