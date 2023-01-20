import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/choose_format_screen.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/viewmodels/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../extensions/size_extension.dart';
import '../mock/media_info.mocks.dart';
import '../mock/mock_audio_imp.dart';
import '../mock/mock_file_utils.dart';
import '../mock/mock_repository.dart';
import '../mock/mock_video_player.dart';

void main() {
  final repository = MockRepositoryImp();
  final homeViewModel = HomeViewModel(repository);
  final easelProvider = EaselProvider(
    repository: repository,
    fileUtilsHelper: MockFileUtilsHelperImp(),
    audioPlayerHelperForFile: MockAudioPlayerHelperImp(),
    audioPlayerHelperForUrl: MockAudioPlayerHelperImp(),
    mediaInfo: MockMediaInfo(),
    videoPlayerHelper: MockVideoPlayerHelperImp(),
  );

  testWidgets("when choosing file for nft creation process indicator should be visible", (widgetTester) async {
    homeViewModel.currentPage = ValueNotifier(1);
    homeViewModel.currentStep = ValueNotifier(1);
    await widgetTester.testAppForWidgetTesting(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: easelProvider),
          ChangeNotifierProvider.value(value: homeViewModel)
        ],
        builder: (context, widget) {
          return const ChooseFormatScreen();
        },
      ),
    );
    final progressSteps = find.byKey(const Key(kProgressStepsKey));
    expect(progressSteps, findsOneWidget);
  });
}
