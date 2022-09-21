import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/describe_screen.dart';
import 'package:easel_flutter/screens/price_screen.dart';
import 'package:easel_flutter/screens/publish_screen.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../extensions/size_extensions.dart';
import '../mock/media_info.mocks.dart';
import '../mock/mock_audio_imp.dart';
import '../mock/mock_constants.dart';
import '../mock/mock_file_utils.dart';
import '../mock/mock_repository.dart';
import '../mock/mock_video_playerock/media_info.mocks.dart';

void main() {
  final repository = MockRepositoryImp();
  final fileUtils = MockFileUtilsHelperImp();
  final videoPlayerHelper = MockVideoPlayerHelperImp();
  final audioPlayerHelper = MockAudioPlayerHelperImp();
  final creatorHubViewModel = CreatorHubViewModel(repository);
  final easelProvider = EaselProvider(
    repository: repository,
    fileUtilsHelper: fileUtils,
    audioPlayerHelperForFile: audioPlayerHelper,
    audioPlayerHelperForUrl: audioPlayerHelper,
    mediaInfo: MockMediaInfo(),
    videoPlayerHelper: videoPlayerHelper,
  );
  final homeViewModel = HomeViewModel(repository);
  homeViewModel.from = kDraft;
  homeViewModel.currentStep = ValueNotifier(0);
  homeViewModel.currentPage = ValueNotifier(0);
  easelProvider.artistNameController = TextEditingController();
  easelProvider.artNameController = TextEditingController();
  easelProvider.descriptionController = TextEditingController();
  easelProvider.royaltyController = TextEditingController();
  easelProvider.noOfEditionController = TextEditingController();
  easelProvider.priceController = TextEditingController();
  easelProvider.artistNameController.text = MOCK_ARTIST_NAME;
  easelProvider.artNameController.text = MOCK_NFT_NAME;
  easelProvider.descriptionController.text = MOCK_DESCRIPTION;
  easelProvider.royaltyController.text = MOCK_ROYALTIES;
  easelProvider.noOfEditionController.text = MOCK_NO_OF_ENTITIES;
  easelProvider.isFreeDrop = FreeDrop.yes;
  easelProvider.nft = MOCK_NFT;
  GetIt.I.registerLazySingleton<Repository>(() => repository);
  GetIt.I.registerLazySingleton(() => homeViewModel);
  GetIt.I.registerLazySingleton(() => creatorHubViewModel);
  GetIt.I.registerLazySingleton(() => easelProvider);
  group("save as draft button test case", () {
    testWidgets("save as draft button on tap describe screen", (tester) async {
      await tester.setScreenSize();
      await tester.testAppForWidgetTesting(
        Scaffold(
          body: MultiProvider(providers: [
            ChangeNotifierProvider.value(value: easelProvider),
            ChangeNotifierProvider.value(value: homeViewModel),
          ], child: const DescribeScreen()),
        ),
      );

      final saveAsDraftButton = find.byKey(const Key(kSaveAsDraftDescKey));
      await tester.ensureVisible(saveAsDraftButton);
      await tester.tap(saveAsDraftButton);
      expect(creatorHubViewModel.selectedCollectionType, CollectionType.draft);
      await tester.pump();
      expect(creatorHubViewModel.selectedCollectionType, CollectionType.draft);
    });

    testWidgets("save as draft button on tap price screen", (tester) async {
      await tester.setScreenSize();
      await tester.testAppForWidgetTesting(
        Scaffold(
          body: MultiProvider(providers: [
            ChangeNotifierProvider.value(value: easelProvider),
            ChangeNotifierProvider.value(value: homeViewModel),
          ], child: const PriceScreen()),
        ),
      );

      final saveAsDraftButton = find.byKey(const Key(kSaveAsDraftPriceKey));
      await tester.ensureVisible(saveAsDraftButton);
      await tester.tap(saveAsDraftButton);
      expect(creatorHubViewModel.selectedCollectionType, CollectionType.draft);
      await tester.pump();
      expect(creatorHubViewModel.selectedCollectionType, CollectionType.draft);
    });

    testWidgets("save as draft button on tap price screen", (tester) async {
      await tester.setScreenSize();
      await tester.testAppForWidgetTesting(
        Scaffold(
          body: MultiProvider(providers: [
            ChangeNotifierProvider.value(value: easelProvider),
            ChangeNotifierProvider.value(value: homeViewModel),
          ], child: const PublishScreen()),
        ),
      );

      final saveAsDraftButton = find.byKey(const Key(kSaveAsDraftPublishKey));
      await tester.ensureVisible(saveAsDraftButton);
      await tester.tap(saveAsDraftButton);
      expect(creatorHubViewModel.selectedCollectionType, CollectionType.draft);
      await tester.pump();
      expect(creatorHubViewModel.selectedCollectionType, CollectionType.draft);
    });
  });
}
