import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsHelper {
  /// This method will set the user id in the firebase
  /// Input: [address] the address of the user
  Future<void> setUserId({required String address});

  /// This method will log the purchase item in the analytics
  /// Input: [recipeId] the id of the NFT, [author] the author of the NFT, [purchasePrice] the price of the NFT, [recipeName] the name of the recipe
  Future<void> logPurchaseItem({required String recipeId, required String recipeName, required String author, required double purchasePrice});
}

class AnalyticsHelperImpl implements AnalyticsHelper {
  FirebaseAnalytics firebaseAnalytics;
  AnalyticsHelperImpl({required this.firebaseAnalytics});

  @override
  Future<void> setUserId({required String address}) async {
    await FirebaseAnalytics.instance.setUserId(id: address);
  }

  @override
  Future<void> logPurchaseItem({required String recipeId, required String recipeName, required String author, required double purchasePrice}) async {
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
}
