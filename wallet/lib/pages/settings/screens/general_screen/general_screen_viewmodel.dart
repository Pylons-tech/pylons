import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';

class GeneralScreenViewModel extends ChangeNotifier {
  bool dropdownVisibility = false;

  String _selectedValue = kTestNet;

  String get selectedValue => _selectedValue;

  set selectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }

  void changeSelectedValue() {
    _selectedValue = _selectedValue == kDevNet ? kTestNet : kDevNet;
    changeDropdownVisibility();
  }

  void changeDropdownVisibility() {
    dropdownVisibility = !dropdownVisibility;
    notifyListeners();
  }

  void getSelectedValue() {
    final networkPreferenceEither =
        GetIt.I.get<Repository>().getNetworkEnvironmentPreference();

    final networkPreference = networkPreferenceEither.getOrElse(() => "");

    if (networkPreference == kDevNet) {
      selectedValue = kDevNet;
    } else {
      selectedValue = kTestNet;
    }
  }


}
