import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsHelper {
  /// This method will set the user id in the firebase
  /// Input: [address] the address of the user
  Future<void> setUserId({required String address});

  /// This method will log the purchase item in the analytics
  /// Input: [recipeId] the id of the NFT, [author] the author of the NFT, [purchasePrice] the price of the NFT, [recipeName] the name of the recipe
  Future<void> logPurchaseItem({required String recipeId, required String recipeName, required String author, required double purchasePrice});

  Future<void> logAddToCart({
    required String recipeId,
    required String recipeName,
    required String author,
    required double purchasePrice,
    required String currency,
  });

  Future<void> logUserJourney({required String screenName});
}

class AnalyticsHelperImpl implements AnalyticsHelper {
  FirebaseAnalytics firebaseAnalytics;
  AnalyticsHelperImpl({required this.firebaseAnalytics});

  @override
  Future<void> setUserId({required String address}) async {
    await FirebaseAnalytics.instance.setUserId(id: address);
  }

  @override
  Future<void> logPurchaseItem({
    required String recipeId,
    required String recipeName,
    required String author,
    required double purchasePrice,
  }) async {
    final item = AnalyticsEventItem(
      itemId: recipeId,
      itemName: recipeName,
      itemCategory: "NFT",
      itemBrand: author,
      price: purchasePrice,
    );

    await FirebaseAnalytics.instance.logSelectItem(
      items: [item],
    );
  }

  @override
  Future<void> logAddToCart({
    required String recipeId,
    required String recipeName,
    required String author,
    required double purchasePrice,
    required String currency,
  }) async {
    final itemWithQuantity = AnalyticsEventItem(
      itemId: recipeId,
      itemName: recipeName,
      itemCategory: "NFT",
      itemBrand: author,
      price: purchasePrice,
      quantity: 1,
    );
    await FirebaseAnalytics.instance.logAddToCart(
      currency: currency,
      value: purchasePrice,
      items: [itemWithQuantity],
    );
  }

  @override
  Future<void> logUserJourney({required String screenName}) async {
    await FirebaseAnalytics.instance.logEvent(name: screenName);
  }
}
