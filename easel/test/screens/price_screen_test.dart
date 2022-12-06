import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/generated/locale_keys.g.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/price_screen.dart';
import 'package:easel_flutter/viewmodels/home_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../extensions/size_extension.dart';
import '../mock/media_info.mocks.dart';
import '../mock/mock_audio_imp.dart';
import '../mock/mock_file_utils.dart';
import '../mock/mock_repository.dart';
import '../mock/mock_video_player.dart';

void main() {
  final repository = MockRepositoryImp();
  GetIt.I.registerLazySingleton<Repository>(() => repository);
  final homeViewModel = HomeViewModel(repository);
  homeViewModel.currentStep = ValueNotifier(0);
  homeViewModel.currentPage = ValueNotifier(0);
  GetIt.I.registerLazySingleton<HomeViewModel>(() => homeViewModel);
  final easelProvider = EaselProvider(
    repository: repository,
    fileUtilsHelper: MockFileUtilsHelperImp(),
    audioPlayerHelperForFile: MockAudioPlayerHelperImp(),
    audioPlayerHelperForUrl: MockAudioPlayerHelperImp(),
    mediaInfo: MockMediaInfo(),
    videoPlayerHelper: MockVideoPlayerHelperImp(),
  );
  easelProvider.isFreeDrop = FreeDrop.no;

  testWidgets("When NFT is not free payment denominations selector should be visible", (widgetTester) async {
    await widgetTester.testAppForWidgetTesting(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: homeViewModel),
          ChangeNotifierProvider.value(value: easelProvider),
        ],
        builder: (context, widget) {
          return const PriceScreen();
        }));

    final creditsWidget = find.text(LocaleKeys.credit_or_debit_card.tr());
    widgetTester.ensureVisible(creditsWidget);
    final appleGooglePayWidget = find.text(LocaleKeys.apple_or_google_play);
    widgetTester.ensureVisible(appleGooglePayWidget);
  });
}
