import 'package:flutter/material.dart';

class NftGridviewViewModel extends ChangeNotifier {
  void onViewOnPylons({required VoidCallback onViewOnPylonsPressed}) {
    onViewOnPylonsPressed.call();
  }

  void startPublishingFlowAgain({required VoidCallback startPublishingFlowAgainPressed}) {
    startPublishingFlowAgainPressed.call();
  }
}
