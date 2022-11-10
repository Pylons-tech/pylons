import 'package:fixnum/fixnum.dart';

import '../../pylons_sdk.dart';
import '../generated/pylons/cookbook.pb.dart' as generated;

class Cookbook {
  final generated.Cookbook _native;

  Cookbook(this._native);

  static Cookbook? _current;
  static Cookbook? get current => _current;

  static Future<Cookbook> load (String id) async {
    final lowLevel = await PylonsWallet.instance.getCookbook(id);
    if (lowLevel.success) {
      return _current = Cookbook(lowLevel.data!);
    } else {
      return Future.error(lowLevel.error);
    }
  }

  static Future<List<Recipe>> recipes () async {
    if (current == null) {
      throw Exception();
    }
    final lowLevel = await PylonsWallet.instance.getRecipes(current!._native.id);
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

  String getCreator() {
    return _native.creator;
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
    return _native.description;
  }

  String getDeveloper() {
    return _native.developer;
  }

  String getVersion() {
    return _native.version;
  }

  String getSupportEmail() {
    return _native.supportEmail;
  }

  bool isEnabled() {
    return _native.enabled;
  }
}