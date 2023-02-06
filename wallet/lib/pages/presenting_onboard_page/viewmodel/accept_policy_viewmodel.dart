// ignore_for_file: avoid_positional_boolean_parameters

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/route_util.dart';

class AcceptPolicyViewModel extends ChangeNotifier {
  final Repository repository;
  final WalletsStore walletsStore;

  AcceptPolicyViewModel({
    required this.repository,
    required this.walletsStore,
  });

  bool isCheckTermServices = false;
  bool isCheckPrivacyPolicy = false;

  void toggleCheckTermServices(bool value) {
    isCheckTermServices = value;
    notifyListeners();
  }

  void toggleCheckPrivacyPolicy(bool value) {
    isCheckPrivacyPolicy = value;
    notifyListeners();
  }

  void setUserAcceptPolicies() {
    repository.saveUserAcceptPolicies();
  }

  void onTapGetStartedButton(NFT nft) {
    setUserAcceptPolicies();
    navigatorKey.currentState!.pushReplacementNamed(RouteUtil.ROUTE_HOME);
    navigatorKey.currentState!.pushNamed(RouteUtil.ROUTE_PURCHASE_VIEW, arguments: nft);
  }

  bool getUserAcceptPolicies() {
    return repository.getUserAcceptPolicies().getOrElse(() => false);
  }

  Future<Either<WalletCreationFailure, String>> createAccountOnChain() {
    return walletsStore.createAccountOnChainWithoutUserName();
  }
}
