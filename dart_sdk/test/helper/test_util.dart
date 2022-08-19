import 'dart:convert';
import 'dart:io';

import 'package:pylons_sdk/pylons_sdk.dart';

import '../mocks/mockedWallet.dart';

/// Utility functions for pylons_wallet_test
class TestUtil {
  /// Set up MockWallet and (TODO) our mock backend stuff.
  static MockWallet mockIpcTarget() {
    return MockWallet();
  }

  /// Load a file out of our test resources folder, get a string
  static String loadFile(String path) {
    final file = File('test_resources/$path');
    return file.readAsStringSync();
  }

  static Cookbook loadCookbook(String path) {
    var json = jsonDecode(loadFile(path));
    final cb = Cookbook.fromJson(json);
    return cb;
  }

  static Recipe loadRecipe(String path) {
    var json = jsonDecode(loadFile(path));
    final rcp = Recipe.fromJson(json);
    return rcp;
  }

  static Trade loadTrade(String path) {
    var json = jsonDecode(loadFile(path));
    final trade = Trade.fromJson(json);
    return trade;
  }
}
