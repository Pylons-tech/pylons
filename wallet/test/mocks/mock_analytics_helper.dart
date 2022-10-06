import 'package:pylons_wallet/services/third_party_services/analytics_helper.dart';

class MockAnalyticsHelper implements AnalyticsHelper {
  @override
  Future<void> setUserId({required String address}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logPurchaseItem({required String recipeId, required String recipeName, required String author, required double purchasePrice}) {
    // TODO: implement logPurchaseItem
    throw UnimplementedError();
  }

  @override
  Future<void> logAddToCart({required String recipeId, required String recipeName, required String author, required double purchasePrice, required String currency}) {
    // TODO: implement logAddToCart
    throw UnimplementedError();
  }
  
  @override
  Future<void> logUserJourney({required String screenName}) {
    // TODO: implement logUserJourney
    throw UnimplementedError();
  }
}
