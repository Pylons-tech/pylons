import 'package:fixnum/fixnum.dart';

import '../../pylons_sdk.dart';
import '../generated/pylons/execution.pb.dart' as generated;

class Execution {
  final generated.Execution _native;

  Execution(this._native);

  Function(Execution)? onSuccess;
  Function(Execution)? onFailure;
  Function(Execution)? onError;

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
    // todo: itemrecord to item wrapper
    throw UnimplementedError();
  }

  Map<String, Int64> getCoinInputs() {
    // todo: List<Coin> to map
    throw UnimplementedError();
  }

  List<Item> getItemOutputs () {
    // todo: get item wrappers for this - do we want to fetch those asap or implement some sort of lazy-fetch?
    throw UnimplementedError();
  }

  List<Item> getModifiedItems () {
    // todo: some sort of nice before/after report?
    throw UnimplementedError();
  }

  Map<String, Int64> getCoinOutputs() {
    // todo: List<Coin> to map
    throw UnimplementedError();
  }
}