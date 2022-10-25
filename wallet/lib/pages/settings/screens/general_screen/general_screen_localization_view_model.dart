import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/share_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';

class GeneralScreenLocalizationViewModel extends ChangeNotifier {
  Locale _local = const Locale('en');
  Repository repository;

  WalletsStore walletStore;
  ShareHelper shareHelper;

  GeneralScreenLocalizationViewModel({required this.walletStore, required this.repository, required this.shareHelper});

  Locale get local => _local;

  void switchLanguage(int index, String name) {
    for (final element in languagesSupported) {
      element['selected'] = false;
    }
    switch (name) {
      case kEnglishText:
        _local = const Locale('en');
        break;
      case kRussianText:
        _local = const Locale('ru');
        break;
      case kIndonesiaText:
        _local = const Locale('id');
        break;
      case kGermanyText:
        _local = const Locale('de');
        break;
      case kKoreanText:
        _local = const Locale('ko');
        break;
      case kJapanText:
        _local = const Locale('ja');
        break;
      case kSpanishText:
        _local = const Locale('es');
        break;
      case kVietnameseText:
        _local = const Locale('vi');
        break;
      default:
        break;
    }
    languagesSupported[index]['selected'] = true;
    notifyListeners();
  }

  Future<void> applyLocal(BuildContext context) async {
    await context.setLocale(_local);
    notifyListeners();
  }

  void setCurrentLanguage(BuildContext context) {
    for (final element in languagesSupported) {
      element['selected'] = false;

      if (context.locale.languageCode == element['languageCode']) {
        element['selected'] = true;
      }
    }
    notifyListeners();
  }

  String getLanguageName(BuildContext context) {
    String name = "";
    for (final element in languagesSupported) {
      if (context.locale.languageCode == element['languageCode']) {
        name = element['name'] as String;
        name = "${name.tr()} ${element['abbreviation']}";
      }
    }

    return name;
  }


  void logScreenEvent(){
    repository.logUserJourney(screenName: AnalyticsScreenEvents.settings);
  }
}
