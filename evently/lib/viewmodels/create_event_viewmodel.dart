import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/models/events.dart';
import 'package:evently/repository/repository.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreateEventViewModel extends ChangeNotifier {
  final Repository repository;

  CreateEventViewModel(this.repository);

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

  Events? events;

  void init({required VoidCallback setTextField}) {
    from = repository.getCacheString(key: fromKey);
    repository.deleteCacheString(key: fromKey);

    if (from == kDraft) {
      events = repository.getCacheDynamicType(key: eventKey) as Events;


      Future.delayed(const Duration(milliseconds: 1), () {
        setTextField.call();
      });

      final uploadStep = events!.step.toUploadStepEnum();

      switch (uploadStep) {
        case UploadStep.overView:
          currentPage = ValueNotifier(1);
          currentStep = ValueNotifier(1);
          pageController = PageController(initialPage: 1);
          return;
        case UploadStep.detail:
          currentPage = ValueNotifier(2);
          currentStep = ValueNotifier(2);
          pageController = PageController(initialPage: 2);
          return;

        case UploadStep.perks:
          currentPage = ValueNotifier(3);
          currentStep = ValueNotifier(3);
          pageController = PageController(initialPage: 3);
          return;

        case UploadStep.price:
          currentPage = ValueNotifier(3);
          currentStep = ValueNotifier(3);
          pageController = PageController(initialPage: 3);
          return;

        case UploadStep.none:
          currentPage = ValueNotifier(0);
          currentStep = ValueNotifier(0);
          pageController = PageController(initialPage: 0);
          return;
      }
    } else {
      currentPage = ValueNotifier(0);
      currentStep = ValueNotifier(0);
      pageController = PageController();
    }
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
