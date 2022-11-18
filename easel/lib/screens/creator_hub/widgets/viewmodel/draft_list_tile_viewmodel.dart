import 'package:flutter/material.dart';

class DraftListViewModel extends ChangeNotifier {
  void startPublishingFlowAgain({required VoidCallback startPublishingFlowAgainPressed}) {
    startPublishingFlowAgainPressed.call();
  }
}
