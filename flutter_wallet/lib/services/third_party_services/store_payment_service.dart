import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pylons_wallet/utils/constants.dart';

abstract class StorePaymentService {
  /// This method will get the products For Sale from the underling store
  /// Input: [itemId] the id of the item
  /// Output: if successful will return [ProductDetails] the details of the product else will throw error
  Future<ProductDetails> getProductsForSale({required String itemId});

  /// This method initialize the in app purchase
  /// [bool] tells whether the device supports in app purchase or not
  Future<bool> isInAppPurchaseAvailable();

  /// This method buys a product that matches product details.
  /// Input : [productDetails] the details of the product that need to be bought
  /// Output: [bool] tells whether the purchase request is sent or not
  Future<bool> buyProduct(ProductDetails productDetails);
}

class StorePaymentServiceImpl implements StorePaymentService {
  InAppPurchase inAppPurchase = InAppPurchase.instance;

  @override
  Future<ProductDetails> getProductsForSale({required String itemId}) async {
    final productDetailResponse =
        await inAppPurchase.queryProductDetails({itemId});

    if (productDetailResponse.error != null) {
      throw SOMETHING_WENT_WRONG;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      throw SOMETHING_WENT_WRONG;
    }

    return productDetailResponse.productDetails.first;
  }

  @override
  Future<bool> buyProduct(ProductDetails productDetails) async {
    return inAppPurchase.buyConsumable(
        purchaseParam: PurchaseParam(productDetails: productDetails));
  }

  @override
  Future<bool> isInAppPurchaseAvailable() {
    return InAppPurchase.instance.isAvailable();
  }
}
