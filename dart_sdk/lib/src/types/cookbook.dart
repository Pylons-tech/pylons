import 'package:fixnum/fixnum.dart';

import '../../pylons_sdk.dart';
import '../generated/pylons/cookbook.pb.dart' as generated;

/// Wrapper object for a cookbook.
/// Exactly one cookbook must be loaded at any one time; this will be used
/// for all recipe, item, etc. queries and operations.
/// Use Cookbook.load() to load the cookbook while your app is setting things up,
/// and then use Cookbook.current when you need to retrieve that.
class Cookbook {
  final generated.Cookbook _native;

  Cookbook(this._native);

  static Cookbook? _current;

  /// Retrieve the current loaded cookbook, or null if none has been loaded.
  static Cookbook? get current => _current;

  /// Async: Retrieve the cookbook with the provided ID from the chain, and then
  /// returns it. Returns an error if the cookbook cannot be loaded.
  static Future<Cookbook> load(String id) async {
    final lowLevel = await PylonsWallet.instance.getCookbook(id);
    if (lowLevel.success) {
      return _current = Cookbook(lowLevel.data!);
    } else {
      return Future.error(lowLevel.error);
    }
  }

  /// Async: Retrieves a list of all recipes in this cookbook.
  static Future<List<Recipe>> recipes() async {
    if (current == null) {
      throw Exception();
    }
    final lowLevel =
        await PylonsWallet.instance.getRecipes(current!._native.id);
    if (lowLevel.success) {
      final ls = <Recipe>[];
      lowLevel.data?.forEach((element) {
        ls.add(Recipe.fromRecipe(element));
      });
      return List.unmodifiable(ls);
    } else {
      return Future.error(lowLevel.error);
    }
  }

  /// Retrieves the address of this cookbook's creator.
  String getCreator() {
    return _native.creator;
  }

  /// Retrieves this cookbook's ID.
  String getId() {
    return _native.id;
  }

  /// Retrieves the node version of this cookbook.
  /// Since all cookbooks are retrieved from the chain,
  /// this should generally just be the current version;
  /// don't worry about it.
  Int64 getNodeVersion() {
    return _native.nodeVersion;
  }

  /// Retrieves the human-readable name of this cookbook.
  String getName() {
    return _native.name;
  }

  /// Retrieves the human-readable description of this cookbook.
  String getDescription() {
    return _native.description;
  }

  /// Retrieves the human-readable developer name of this cookbook.
  String getDeveloper() {
    return _native.developer;
  }

  /// Retrieves the human-readable name of this cookbook.
  String getVersion() {
    return _native.version;
  }

  /// Retrieves the support email address of this cookbook.
  String getSupportEmail() {
    return _native.supportEmail;
  }

  /// Retrieves the enabled status of this cookbook.
  bool isEnabled() {
    return _native.enabled;
  }
}
