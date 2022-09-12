import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
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
    final response = await walletStore.executeRecipe(txDataJson as Map<dynamic, dynamic>);
    if (response.isLeft()){
      "something_wrong".tr().show();
      loading.dismiss();
      return;
    }
    loading.dismiss();
    "purchase_successful".tr().show();
    await deleteFailure(id: txManager.id!);
  }

  Future<void> retryGeneratePaymentReceipt(LocalTransactionModel txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final StripeGeneratePaymentReceiptRequest request = StripeGeneratePaymentReceiptRequest.fromJson(txDataJson as Map<String, dynamic>);
    final loading = Loading()..showLoading();
    final response = await repository.GeneratePaymentReceipt(request);
    if (response.isLeft()){
      "something_wrong".tr().show();
      loading.dismiss();
      return;
    }
    loading.dismiss();
  }


  Future<void> retryAppleInAppCoinsRequest(LocalTransactionModel txManager) async {
    final txDataJson = jsonDecode(txManager.transactionData);
    final AppleInAppPurchaseModel request = AppleInAppPurchaseModel.fromJson(txDataJson as Map<String, dynamic>);
    final loading = Loading()..showLoading();
    final response = await repository.sendAppleInAppPurchaseCoinsRequest(request);
    if (response.isLeft()){
      "something_wrong".tr().show();
      loading.dismiss();
      return;
    }
    await deleteFailure(id: txManager.id!);
    GetIt.I.get<HomeProvider>().buildAssetsList();
    "purchase_successful".tr().show();
    loading.dismiss();
  }

  Future<void> retryGoogleInAppCoinsRequest(LocalTransactionModel txManager) async {
    final loading = Loading()..showLoading();
    final txDataJson = jsonDecode(txManager.transactionData);
    final GoogleInAppPurchaseModel request = GoogleInAppPurchaseModel.fromJson(txDataJson as Map<String, dynamic>);
    final response = await repository.sendGoogleInAppPurchaseCoinsRequest(request);
    if (response.isLeft()){
      "something_wrong".tr().show();
      loading.dismiss();
      return;
    }
    await deleteFailure(id: txManager.id!);
    GetIt.I.get<HomeProvider>().buildAssetsList();
    "purchase_successful".tr().show();
    loading.dismiss();
  }
}
