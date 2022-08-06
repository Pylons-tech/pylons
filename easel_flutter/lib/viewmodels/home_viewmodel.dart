import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class HomeViewModel extends ChangeNotifier {
  final Repository repository;

  HomeViewModel(this.repository);

  late ValueNotifier<int> currentPage;

  late ValueNotifier<int> currentStep;
  late PageController pageController;

  NFT? nft;
  String? from;
  final List pageTitles = ["upload".tr(), "nft_detail_text".tr(), "nft_pricing".tr(), ''];

  void init({required VoidCallback setTextField}) {
    from = repository.getCacheString(key: fromKey);
    repository.deleteCacheString(key: fromKey);

    if (from == kDraft) {
      nft = repository.getCacheDynamicType(key: nftKey);

      Future.delayed(const Duration(milliseconds: 1), () {
        setTextField.call();
      });

      final uploadStep = nft!.step.toUploadStepEnum();

      switch (uploadStep) {
        case UploadStep.assetUploaded:
          currentPage = ValueNotifier(1);
          currentStep = ValueNotifier(1);
          pageController = PageController(keepPage: true, initialPage: 1);
          return;

        case UploadStep.descriptionAdded:
          currentPage = ValueNotifier(1);
          currentStep = ValueNotifier(1);
          pageController = PageController(keepPage: true, initialPage: 2);
          break;
        case UploadStep.priceAdded:
          currentPage = ValueNotifier(3);
          currentStep = ValueNotifier(2);
          pageController = PageController(keepPage: true, initialPage: 3);
          break;
        case UploadStep.none:
          currentPage = ValueNotifier(0);
          currentStep = ValueNotifier(0);
          pageController = PageController(keepPage: true, initialPage: 0);
          break;
      }
    } else {
      currentPage = ValueNotifier(0);
      currentStep = ValueNotifier(0);
      pageController = PageController(keepPage: true, initialPage: 0);
    }
  }

  void nextPage() async {
    await pageController.nextPage(duration: const Duration(milliseconds: kPageAnimationTimeInMillis), curve: Curves.easeIn);
    notifyListeners();
  }

  void previousPage() async {

    await pageController.previousPage(duration: const Duration(milliseconds: kPageAnimationTimeInMillis), curve: Curves.easeIn);

    notifyListeners();
  }

  void disposeControllers() {
    pageController.dispose();
  }
}
