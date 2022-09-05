import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_request.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';

class FailureManagerViewModel extends ChangeNotifier {
  final Repository repository;

  FailureManagerViewModel({required this.repository});

  Future<List<LocalTransactionModel>> getAllFailuresFromDB() async {
    final failureEither = await repository.getAllTransactionFailures();
    if (failureEither.isLeft()) {
      return [];
    }

    return failureEither.getOrElse(() => []);
  }

  Future<void> handleRetry({required LocalTransactionModel txManager}) async {
    final TransactionTypeEnum failureTypeEnum = txManager.transactionType.toTransactionTypeEnum();

    switch (failureTypeEnum) {
      case TransactionTypeEnum.GeneratePaymentReceipt:
        retryGeneratePaymentReceipt(txManager);
        break;
      case TransactionTypeEnum.UpdateLikeStatus:
        retryUpdateLikeStatus(txManager);
        break;
      // case TransactionTypeEnum.StripePayout:
      //   retryStripePayout(txManager);
      //   break;
      case TransactionTypeEnum.AppleInAppCoinsRequest:
        retryAppleInAppCoinsRequest(txManager);
        break;
      case TransactionTypeEnum.GoogleInAppCoinsRequest:
        retryGoogleInAppCoinsRequest(txManager);
        break;
      case TransactionTypeEnum.BuyProduct:
        retryBuyProduct(txManager);
        break;
      case TransactionTypeEnum.Unknown:
        'something_wrong'.tr().show();
        break;
    }
  }

  Future deleteFailure({required int id}) async {
    await repository.deleteTransactionFailureRecord(id);
    getAllFailuresFromDB();
  }

  Future<void> retryUpdateLikeStatus(LocalTransactionModel txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final loading = Loading()..showLoading();
    await repository.updateLikeStatus(recipeId: txDataJson[kRecipeIdMap].toString(), cookBookID: txDataJson[kCookbookIdMap].toString(), walletAddress: txDataJson[kWalletAddressIdMap].toString());
    deleteFailure(id: txManager.id!);
    loading.dismiss();
  }

  Future<void> retryGeneratePaymentReceipt(LocalTransactionModel txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final StripeGeneratePaymentReceiptRequest request = StripeGeneratePaymentReceiptRequest.fromJson(txDataJson as Map<String, dynamic>);
    final loading = Loading()..showLoading();
    await repository.GeneratePaymentReceipt(request);
    loading.dismiss();
  }


  Future<void> retryBuyProduct(LocalTransactionModel txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final ProductDetails productDetails = ProductDetails(
        id: txDataJson['id'] as String,
        title: txDataJson['title'] as String,
        description: txDataJson['description'] as String,
        price: txDataJson['price'] as String,
        rawPrice: double.parse(txDataJson['rawPrice'] as String),
        currencyCode: txDataJson['currencyCode'] as String);
    final loading = Loading()..showLoading();
    await repository.buyProduct(productDetails);
    loading.dismiss();
  }

  Future<void> retryAppleInAppCoinsRequest(LocalTransactionModel txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final AppleInAppPurchaseModel request = AppleInAppPurchaseModel.fromJson(txDataJson as Map<String, dynamic>);
    final loading = Loading()..showLoading();
    await  repository.sendAppleInAppPurchaseCoinsRequest(request);
    loading.dismiss();
  }

  Future<void> retryGoogleInAppCoinsRequest(LocalTransactionModel txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final GoogleInAppPurchaseModel request = GoogleInAppPurchaseModel.fromJson(txDataJson as Map<String, dynamic>);
    final loading = Loading()..showLoading();
    await repository.sendGoogleInAppPurchaseCoinsRequest(request);
    loading.dismiss();
  }
}
