import 'package:fixnum/fixnum.dart';

import '../../pylons_sdk.dart';
import '../generated/pylons/execution.pb.dart' as generated;

class Execution {
  final generated.Execution _native;

  Execution(this._native);

  String getCreator() {
    return _native.creator;
  }

  String getId() {
    return _native.id;
  }

  String getCookbookId() {
    return _native.cookbookId;
  }

  String getRecipeId() {
    return _native.recipeId;
  }

  String getRecipeVersion() {
    return _native.recipeVersion;
  }

  Int64 getNodeVersion () {
    return _native.nodeVersion;
  }

  // todo: get a datetime and provide that instead/in addition to block height
  Int64 getBlockHeight () {
    return _native.blockHeight;
  }

  List<Item> getItemInputs () {
    var ls = <Item>[];
    _native.itemInputs.forEach((element) {
      ls.add(Item.fromRecord(element));
    });
    return List.unmodifiable(ls);
  }

  Map<String, Int64> getCoinInputs() {
    var map = <String, Int64>{};
    _native.coinInputs.forEach((element) {
      map[element.denom] = Int64.parseInt(element.amount);
    });
    return Map.unmodifiable(map);
  }

  List<String> getItemOutputIds () {
    // it'd be very nice to have some sort of clever lazy-item thing going on, down the road
    // we can't just fetch each of these individually, so
    return List.unmodifiable(_native.itemOutputIds);
  }

  List<String> getModifiedItemIds () {
    // todo: some sort of nice before/after report? but idek what that looks like
    return List.unmodifiable(_native.itemModifyOutputIds);
  }

  Map<String, Int64> getCoinOutputs() {
    var map = <String, Int64>{};
    _native.coinOutputs.forEach((element) {
      map[element.denom] = Int64.parseInt(element.amount);
    });
    return Map.unmodifiable(map);
  }
}