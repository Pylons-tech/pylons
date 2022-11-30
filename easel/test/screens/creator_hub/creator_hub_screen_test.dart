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

  group("Published tab tests", () {
    testWidgets("Published Button Color Test", (tester) async {
      await tester.setScreenSize();
      easelProvider.isPylonsInstalled = true;
      creatorHubViewModel.viewType = ViewType.viewList;
      creatorHubViewModel.selectedCollectionType = CollectionType.published;
      creatorHubViewModel.nftPublishedList.add(MOCK_NFT);
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
      final publishedButtonKey = find.byKey(const Key(kSelectedPublishedButtonKey));
      await tester.ensureVisible(publishedButtonKey);
      final DecoratedBox decoratedBox = tester.firstWidget(publishedButtonKey) as DecoratedBox;
      final BoxDecoration boxDecoration = decoratedBox.decoration as BoxDecoration;
      expect(boxDecoration.color, EaselAppTheme.kDarkGreen);
    });

    testWidgets("Testing refresh published NFT button visibility", (tester) async {
      await tester.setScreenSize();
      easelProvider.isPylonsInstalled = true;
      creatorHubViewModel.viewType = ViewType.viewList;
      creatorHubViewModel.selectedCollectionType = CollectionType.published;
      creatorHubViewModel.nftPublishedList.add(MOCK_NFT);
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
      final publishButtonKey = find.byKey(const Key(kRefreshPublishedNFTButtonKey));
      await tester.ensureVisible(publishButtonKey);
    });
  });

  testWidgets("Drafts Button Color Test", (tester) async {
    await tester.setScreenSize();
    easelProvider.isPylonsInstalled = true;
    creatorHubViewModel.viewType = ViewType.viewList;
    creatorHubViewModel.selectedCollectionType = CollectionType.draft;
    creatorHubViewModel.nftPublishedList.add(MOCK_NFT);
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
    final draftButtonKey = find.byKey(const Key(kSelectedDraftButtonKey));
    await tester.ensureVisible(draftButtonKey);
    final DecoratedBox decoratedBox = tester.firstWidget(draftButtonKey) as DecoratedBox;
    final BoxDecoration boxDecoration = decoratedBox.decoration as BoxDecoration;
    expect(boxDecoration.color, EaselAppTheme.kLightRed);
  });

}
