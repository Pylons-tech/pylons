import 'dart:convert';
import 'dart:io';

import 'package:pylons_sdk/low_level.dart' as ll;

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

  static ll.Cookbook loadCookbook(String path) {
    var json = jsonDecode(loadFile(path));
    final cb = ll.Cookbook.fromJson(json);
    return cb;
  }

  static ll.Recipe loadRecipe(String path) {
    var json = jsonDecode(loadFile(path));
    final rcp = ll.Recipe.fromJson(json);
    return rcp;
  }

  static ll.Trade loadTrade(String path) {
    var json = jsonDecode(loadFile(path));
    final trade = ll.Trade.fromJson(json);
    return trade;
  }
}
