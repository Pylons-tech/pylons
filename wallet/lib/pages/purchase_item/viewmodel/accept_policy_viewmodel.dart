// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';

class AcceptPolicyViewModel extends ChangeNotifier {
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
}
