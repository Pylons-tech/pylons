import 'package:mockito/mockito.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

class MockWallet extends Mock implements PylonsWallet {
  List<Cookbook> cookbooks = [];
  List<Recipe> recipes = [];
  List<Trade> trades = [];

  /// Load the provided cookbooks. We'll use these to mock getCookbooks.
  void loadCookbooks(List<Cookbook> cbs) {
    cookbooks.addAll(cbs);
  }

  void loadRecipes(List<Recipe> rcps) {
    recipes.addAll(rcps);
  }

  void loadTrades(List<Trade> trade) {
    trades.addAll(trade);
  }
}
