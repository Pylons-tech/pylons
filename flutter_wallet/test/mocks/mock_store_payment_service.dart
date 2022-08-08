import 'package:in_app_purchase_platform_interface/src/types/product_details.dart';
import 'package:pylons_wallet/services/third_party_services/store_payment_service.dart';

class MockStripePaymentService implements StorePaymentService {
  @override
  Future<bool> buyProduct(ProductDetails productDetails) {
    // TODO: implement buyProduct
    throw UnimplementedError();
  }

  @override
  Future<ProductDetails> getProductsForSale({required String itemId}) {
    // TODO: implement getProductsForSale
    throw UnimplementedError();
  }

  @override
  Future<bool> isInAppPurchaseAvailable() {
    // TODO: implement isInAppPurchaseAvailable
    throw UnimplementedError();
  }
}
