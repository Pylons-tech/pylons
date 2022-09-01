import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_request.dart';
import 'package:pylons_wallet/model/stripe_payout_request.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';

class FailureManagerViewModel extends ChangeNotifier {
  final Repository repository;

  FailureManagerViewModel({required this.repository});

  Future<List<TransactionManager>> getAllFailuresFromDB() async {
    final failureEither = await repository.getAllTransactionFailures();

    if (failureEither.isLeft()) {
      return [];
    }

    return failureEither.getOrElse(() => []);
  }

  Future<void> handleRetry({required TransactionManager txManager}) async {
    final FailureTypeEnum failureTypeEnum = txManager.transactionType.toFailureTypeEnum();

    switch (failureTypeEnum) {
      case FailureTypeEnum.GeneratePaymentReceipt:
        retryGeneratePaymentReceipt(txManager);
        break;
      case FailureTypeEnum.UpdateLikeStatus:
        retryUpdateLikeStatus(txManager);
        break;
      case FailureTypeEnum.StripePayout:
        retryStripePayout(txManager);
        break;
      case FailureTypeEnum.AppleInAppCoinsRequest:
        retryAppleInAppCoinsRequest(txManager);
        break;
      case FailureTypeEnum.GoogleInAppCoinsRequest:
        retryGoogleInAppCoinsRequest(txManager);
        break;
      case FailureTypeEnum.BuyProduct:
        retryBuyProduct(txManager);
        break;
      case FailureTypeEnum.Unknown:
        retryUpdateLikeStatus(txManager);
        break;
    }
  }

  Future retryUpdateLikeStatus(TransactionManager txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final loading = Loading()..showLoading();
    repository.updateLikeStatus(recipeId: txDataJson[kRecipeIdMap].toString(), cookBookID: txDataJson[kCookbookIdMap].toString(), walletAddress: txDataJson[kWalletAddressIdMap].toString());
    loading.dismiss();
  }

  Future retryGeneratePaymentReceipt(TransactionManager txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final StripeGeneratePaymentReceiptRequest request = StripeGeneratePaymentReceiptRequest.fromJson(txDataJson as Map<String, dynamic>);
    final loading = Loading()..showLoading();
    repository.GeneratePaymentReceipt(request);
    loading.dismiss();
  }

  Future retryStripePayout(TransactionManager txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final StripePayoutRequest request = StripePayoutRequest.fromJson(txDataJson as Map<String, dynamic>);
    final loading = Loading()..showLoading();
    repository.Payout(request);
    loading.dismiss();
  }

  Future retryBuyProduct(TransactionManager txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final ProductDetails productDetails = ProductDetails(
        id: txDataJson['id'] as String,
        title: txDataJson['title'] as String,
        description: txDataJson['description'] as String,
        price: txDataJson['price'] as String,
        rawPrice: double.parse(txDataJson['rawPrice'] as String),
        currencyCode: txDataJson['currencyCode'] as String);
    final loading = Loading()..showLoading();
    repository.buyProduct(productDetails);
    loading.dismiss();
  }

  Future retryAppleInAppCoinsRequest(TransactionManager txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final AppleInAppPurchaseModel request = AppleInAppPurchaseModel.fromJson(txDataJson as Map<String, dynamic>);
    final loading = Loading()..showLoading();
    repository.sendAppleInAppPurchaseCoinsRequest(request);
    loading.dismiss();
  }

  Future retryGoogleInAppCoinsRequest(TransactionManager txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final GoogleInAppPurchaseModel request = GoogleInAppPurchaseModel.fromJson(txDataJson as Map<String, dynamic>);
    final loading = Loading()..showLoading();
    repository.sendGoogleInAppPurchaseCoinsRequest(request);
    loading.dismiss();
  }
}
