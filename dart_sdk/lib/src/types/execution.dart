// import 'package:fixnum/fixnum.dart';
//
// import '../../pylons_sdk.dart';
// import '../generated/pylons/execution.pb.dart' as generated;

/// Wrapper object for a recipe execution.
/// The underlying functionality this object wraps is
/// not currently operational, so it's just a stub object.
class Execution {
//  final generated.Execution _native;

//  Execution(this._native);

  // /// TODO
  // Future<Execution?> refresh() async {
  //   final ll = await PylonsWallet.instance.getExecutionBasedOnId(id: _native.id);
  //   if (ll.data != null) {
  //     return Execution(ll.data!);
  //   } else {
  //     return null;
  //   }
  // }
  //
  // /// Retrieves the address of the party that executed the recipe.
  // /// In most typical cases, this is the current user of your application.
  // String getCreator() {
  //   return _native.creator;
  // }
  //
  // /// Retrieves the ID of the execution.
  // String getId() {
  //   return _native.id;
  // }
  //
  // /// Retrieves the ID of the cookbook the recipe being executed was in.
  // String getCookbookId() {
  //   return _native.cookbookId;
  // }
  //
  // /// Retrieves the ID of the recipe being executed.
  // String getRecipeId() {
  //   return _native.recipeId;
  // }
  //
  // /// Retrieves the version of the recipe being executed.
  // String getRecipeVersion() {
  //   return _native.recipeVersion;
  // }
  //
  // /// Retrieves the node version as of this execution.
  // Int64 getNodeVersion () {
  //   return _native.nodeVersion;
  // }
  //
  // /// Retrieves the current block height as of this execution.
  // // todo: get a datetime and provide that instead/in addition to block height
  // Int64 getBlockHeight () {
  //   return _native.blockHeight;
  // }
  //
  // /// Retrieves a list of all items input to this execution.
  // List<Item> getItemInputs () {
  //   var ls = <Item>[];
  //   _native.itemInputs.forEach((element) {
  //     ls.add(Item.fromRecord(element));
  //   });
  //   return List.unmodifiable(ls);
  // }
  //
  // /// Retrieves a map of all coins input to this execution.
  // Map<String, Int64> getCoinInputs() {
  //   var map = <String, Int64>{};
  //   _native.coinInputs.forEach((element) {
  //     map[element.denom] = Int64.parseInt(element.amount);
  //   });
  //   return Map.unmodifiable(map);
  // }
  //
  // /// Retrieves the IDs of all items output by this execution.
  // /// In order to get additional details, you'll need to call Item.get()
  // /// with each of these IDs; you can try to hide that behind a UI transition.
  // List<String> getItemOutputIds () {
  //   // it'd be very nice to have some sort of clever lazy-item thing going on, down the road
  //   // we can't just fetch each of these individually, so
  //   return List.unmodifiable(_native.itemOutputIds);
  // }
  //
  // /// Retrieves the IDs of all items modified by this execution.
  // /// In order to get additional details, you'll need to call Item.get()
  // /// with each of these IDs; you can try to hide that behind a UI transition.
  // List<String> getModifiedItemIds () {
  //   // todo: some sort of nice before/after report? but idek what that looks like
  //   return List.unmodifiable(_native.itemModifyOutputIds);
  // }
  //
  // /// Retrieves a map of all coins output by this execution.
  // Map<String, Int64> getCoinOutputs() {
  //   var map = <String, Int64>{};
  //   _native.coinOutputs.forEach((element) {
  //     map[element.denom] = Int64.parseInt(element.amount);
  //   });
  //   return Map.unmodifiable(map);
  // }
}