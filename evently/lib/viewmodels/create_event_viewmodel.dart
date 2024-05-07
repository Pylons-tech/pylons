import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
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
  final List<String> pageTitles = <String>[
    LocaleKeys.overview.tr(),
    LocaleKeys.detail.tr(),
    LocaleKeys.perks.tr(),
    LocaleKeys.price.tr(),
  ];

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
