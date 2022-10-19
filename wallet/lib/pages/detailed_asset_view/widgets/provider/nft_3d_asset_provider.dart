import 'package:flutter/material.dart';

class Nft3DAssetProvider extends ChangeNotifier {
  final ValueNotifier<bool> _showLoader = ValueNotifier(true);

  ValueNotifier<bool> get showLoader => _showLoader;

  void toggleLoader() {
    _showLoader.value = false;
    notifyListeners();
  }
}
