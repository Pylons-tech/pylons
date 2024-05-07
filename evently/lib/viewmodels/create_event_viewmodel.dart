import 'package:evently/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreateEventViewModel extends ChangeNotifier {
  CreateEventViewModel();

  late ValueNotifier<int> currentPage;
  late ValueNotifier<int> currentStep;
  late PageController pageController;

  String? from;
  final List<String> pageTitles = <String>['LocaleKeys.upload.tr()', ' LocaleKeys.nft_detail_text.tr()', ' LocaleKeys.nft_pricing.tr()', ''];

  void init({required VoidCallback setTextField}) {
    currentPage = ValueNotifier(0);
    currentStep = ValueNotifier(0);
    pageController = PageController();
  }

  Future<void> nextPage() async {
    await pageController.nextPage(duration: const Duration(milliseconds: kPageAnimationTimeInMillis), curve: Curves.easeIn);
    notifyListeners();
  }

  Future<void> previousPage() async {
    from = kDraft;
    await pageController.previousPage(duration: const Duration(milliseconds: kPageAnimationTimeInMillis), curve: Curves.easeIn);

    notifyListeners();
  }

  void disposeControllers() {
    pageController.dispose();
  }
}
