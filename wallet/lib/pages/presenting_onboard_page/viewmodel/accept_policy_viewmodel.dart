// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:pylons_wallet/services/repository/repository.dart';

class AcceptPolicyViewModel extends ChangeNotifier {
  final Repository repository;

  AcceptPolicyViewModel({required this.repository});

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

  bool getUserAcceptPolicies() {
    return repository.getUserAcceptPolicies().getOrElse(() => false);
  }
}
