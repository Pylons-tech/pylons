import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_screen.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../extensions/size_extension.dart';
import '../../mock/media_info.mocks.dart';
import '../../mock/mock_audio_imp.dart';
import '../../mock/mock_constants.dart';
import '../../mock/mock_file_utils.dart';
import '../../mock/mock_repository.dart';
import '../../mock/mock_video_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repository = MockRepositoryImp();
  final creatorHubViewModel = CreatorHubViewModel(repository);
  GetIt.I.registerLazySingleton(() => creatorHubViewModel);

  final fileUtils = MockFileUtilsHelperImp();
  final videoPlayerHelper = MockVideoPlayerHelperImp();
  final audioPlayerHelper = MockAudioPlayerHelperImp();
  final easelProvider = EaselProvider(
    repository: repository,
    fileUtilsHelper: fileUtils,
    audioPlayerHelperForFile: audioPlayerHelper,
    audioPlayerHelperForUrl: audioPlayerHelper,
    mediaInfo: MockMediaInfo(),
    videoPlayerHelper: videoPlayerHelper,
  );
  GetIt.I.registerLazySingleton(() => easelProvider);

  group("Creator Hub", () {
    setUp(()async{
      easelProvider.isPylonsInstalled = true;
      creatorHubViewModel.viewType = ViewType.viewList;
      creatorHubViewModel.selectedCollectionType = CollectionType.published;
      creatorHubViewModel.nftPublishedList.add(MOCK_NFT);
    });
    
    testWidgets("when draft tab is active testing draft button color", (tester) async {
      creatorHubViewModel.selectedCollectionType = CollectionType.draft;
      await renderWidget(tester: tester, easelProvider: easelProvider, creatorHubViewModel: creatorHubViewModel);
      final draftButtonKey = find.byKey(const Key(kSelectedDraftButtonKey));
      await tester.ensureVisible(draftButtonKey);
      final DecoratedBox decoratedBox = tester.firstWidget(draftButtonKey) as DecoratedBox;
      final BoxDecoration boxDecoration = decoratedBox.decoration as BoxDecoration;
      expect(boxDecoration.color, EaselAppTheme.kLightRed);
    });

    testWidgets("when publish tab is active testing publishing button color", (tester) async {
      await renderWidget(tester: tester, easelProvider: easelProvider, creatorHubViewModel: creatorHubViewModel);
      final publishedButtonKey = find.byKey(const Key(kSelectedPublishedButtonKey));
      await tester.ensureVisible(publishedButtonKey);
      final DecoratedBox decoratedBox = tester.firstWidget(publishedButtonKey) as DecoratedBox;
      final BoxDecoration boxDecoration = decoratedBox.decoration as BoxDecoration;
      expect(boxDecoration.color, EaselAppTheme.kDarkGreen);
    });

    testWidgets("when published tab is active testing refresh nft button visibility", (tester) async {
      await renderWidget(tester: tester, easelProvider: easelProvider, creatorHubViewModel: creatorHubViewModel);
      final publishButtonKey = find.byKey(const Key(kRefreshPublishedNFTButtonKey));
      await tester.ensureVisible(publishButtonKey);
    });
  });
}

Future<void> renderWidget({required WidgetTester tester, required EaselProvider easelProvider, required CreatorHubViewModel creatorHubViewModel})async{
  await tester.setScreenSize();
  await tester.testAppForWidgetTesting(
    Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: easelProvider),
          ChangeNotifierProvider.value(value: creatorHubViewModel),
        ],
        child: const CreatorHubContent(),
      ),
    ),
  );
}