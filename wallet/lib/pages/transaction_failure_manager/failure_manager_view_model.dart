import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
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
        // TODO: Handle this case.
        break;
      case FailureTypeEnum.UpdateLikeStatus:
        retryUpdateLikeStatus(txManager);
        break;
      case FailureTypeEnum.StripePayout:
        // TODO: Handle this case.
        break;
      case FailureTypeEnum.AppleInAppCoinsRequest:
        // TODO: Handle this case.
        break;
      case FailureTypeEnum.GoogleInAppCoinsRequest:
        // TODO: Handle this case.
        break;
      case FailureTypeEnum.BuyProduct:
        // TODO: Handle this case.
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
}
