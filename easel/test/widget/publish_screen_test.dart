import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_screen.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/widgets/publish_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../extensions/size_extensions.dart';
import '../mock/media_info.mocks.dart';
import '../mock/mock_audio_imp.dart';
import '../mock/mock_file_utils.dart';
import '../mock/mock_repository.dart';
import '../mock/mock_video_player.dart';
import '../mocks/mock_constants.dart';

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

  group("publish button test case", () {
    testWidgets("publish button on tap", (tester) async {
      await tester.setScreenSize();

      await tester.testAppForWidgetTesting(
        Builder(
          builder: (context) {
            ScreenUtil.init(context);
            return Material(
              child: PublishButton(
                onPress: () {
                  GetIt.I.get<CreatorHubViewModel>().changeSelectedCollection(CollectionType.published);
                },
              ),
            );
          },
        ),
      );

      final publishButtonKey = find.byKey(const Key(kPublishButtonKey));
      expect(creatorHubViewModel.selectedCollectionType, CollectionType.draft);
      await tester.ensureVisible(publishButtonKey);
      await tester.tap(publishButtonKey);
      await tester.pump();
      expect(creatorHubViewModel.selectedCollectionType, CollectionType.published);
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
}
