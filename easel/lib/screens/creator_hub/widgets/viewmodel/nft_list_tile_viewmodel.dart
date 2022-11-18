import 'package:flutter/material.dart';

class NftListViewModel extends ChangeNotifier {
  void onViewOnPylons({required VoidCallback onViewOnPylonsPressed}) {
    onViewOnPylonsPressed.call();
  }
}
