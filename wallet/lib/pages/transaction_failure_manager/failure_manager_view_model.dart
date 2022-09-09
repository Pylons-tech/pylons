import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_request.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';

class FailureManagerViewModel extends ChangeNotifier {
  final Repository repository;

  FailureManagerViewModel({required this.repository});

  Future<void> getAllFailuresFromDB() async {
    final failureEither = await repository.getAllTransactionFailures();
    if (failureEither.isLeft()) {
      localTransactionsList = [];
      notifyListeners();
      'something_wrong'.tr().show();
      return;
    }

    localTransactionsList = failureEither.getOrElse(() => []);
    notifyListeners();
  }

  List<LocalTransactionModel> localTransactionsList = [];

  Future<void> handleRetry({required LocalTransactionModel txManager}) async {
    final TransactionTypeEnum failureTypeEnum = txManager.transactionType.toTransactionTypeEnum();
    switch (failureTypeEnum) {
      case TransactionTypeEnum.GeneratePaymentReceipt:
        retryGeneratePaymentReceipt(txManager);
        break;
      case TransactionTypeEnum.BuyNFT:
        retryBuyNFT(txManager);
        break;
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
    await getAllFailuresFromDB();
  }

  Future<void> retryBuyNFT(LocalTransactionModel txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final loading = Loading()..showLoading();
    final walletStore = GetIt.I.get<WalletsStore>();
    await walletStore.executeRecipe(txDataJson as Map<dynamic, dynamic>);
    await deleteFailure(id: txManager.id!);
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
        id: txDataJson['id'].toString(),
        title: txDataJson['title'].toString(),
        description: txDataJson['description'].toString(),
        price: txDataJson['price'].toString(),
        rawPrice: double.parse(txDataJson['rawPrice'].toString()),
        currencyCode: txDataJson['currencyCode'].toString());
    final loading = Loading()..showLoading();
    await repository.buyProduct(productDetails);
    await deleteFailure(id: txManager.id!);
    loading.dismiss();
  }

  Future<void> retryAppleInAppCoinsRequest(LocalTransactionModel txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final AppleInAppPurchaseModel request = AppleInAppPurchaseModel.fromJson(txDataJson as Map<String, dynamic>);
    final loading = Loading()..showLoading();
    await repository.sendAppleInAppPurchaseCoinsRequest(request);
    GetIt.I.get<HomeProvider>().buildAssetsList();
    "purchase_successful".tr().show();
    loading.dismiss();
  }

  Future<void> retryGoogleInAppCoinsRequest(LocalTransactionModel txManager) async {
    final loading = Loading()..showLoading();
    final txDataJson = jsonDecode(txManager.transactionData);
    final GoogleInAppPurchaseModel request = GoogleInAppPurchaseModel.fromJson(txDataJson as Map<String, dynamic>);
    await repository.sendGoogleInAppPurchaseCoinsRequest(request);
    await deleteFailure(id: txManager.id!);
    GetIt.I.get<HomeProvider>().buildAssetsList();
    loading.dismiss();
  }
}
