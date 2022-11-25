import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/owner_view/owner_view.dart';
import 'package:easel_flutter/screens/owner_view/viewmodel/owner_view_viewmodel.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/widgets/audio_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../extensions/size_extension.dart';
import '../../mock/easel_provider.mocks.dart';
import '../../mock/mock_constants.dart';
import '../../mock/owner_view_viewmodel.mocks.dart';

void main() {
  final viewModel = MockOwnerViewViewModel();
  final easelViewModel = MockEaselProvider();
  GetIt.I.registerLazySingleton<OwnerViewViewModel>(() => viewModel);
  GetIt.I.registerLazySingleton<EaselProvider>(() => easelViewModel);

  group("Test cases for Owner view screen", () {
    testWidgets("do Image nft is showing to user or not", (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_NFT);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.collapsed).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        OwnerView(
          nft: MOCK_PRICED_NFT,
        ),
      );
      await tester.pump();
      final imageWidget = find.byKey(const Key(kImageWidgetKey));
      expect(imageWidget, findsOneWidget);
    });

    testWidgets("do Video nft is showing to user or not", (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_Video_NFT);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.collapsed).thenAnswer((realInvocation) => true);
      when(easelViewModel.isVideoLoading).thenAnswer((realInvocation) => false);
      when(easelViewModel.videoLoadingError).thenAnswer((realInvocation) => '');
      when(easelViewModel.videoPlayerController).thenAnswer((realInvocation) => VideoPlayerController.network(MOCK_PRICED_Video_NFT.url));
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider.value(
            value: GetIt.I.get<EaselProvider>(),
            builder: (context, child) {
              return OwnerView(
                nft: MOCK_PRICED_Video_NFT,
              );
            }),
      );
      await tester.pump();
      final imageWidget = find.byKey(const Key(kVideoWidgetKey));
      expect(imageWidget, findsOneWidget);
    });

    testWidgets("do audio nft is showing to user or not", (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_AUDIO_NFT);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.collapsed).thenAnswer((realInvocation) => true);
      when(easelViewModel.collapsed).thenAnswer((realInvocation) => true);
      when(easelViewModel.buttonNotifier).thenAnswer((realInvocation) => ValueNotifier(ButtonState.playing));
      when(easelViewModel.audioProgressNotifier).thenAnswer(
        (realInvocation) => ValueNotifier(
          ProgressBarState(
            current: const Duration(seconds: 4),
            buffered: const Duration(seconds: 1),
            total: const Duration(seconds: 10),
          ),
        ),
      );
      when(easelViewModel.initializeAudioPlayer(publishedNFTUrl: MOCK_PRICED_AUDIO_NFT.url)).thenAnswer((realInvocation) async {
        return true;
      });
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider.value(
            value: GetIt.I.get<EaselProvider>(),
            builder: (context, child) {
              return OwnerView(
                nft: MOCK_PRICED_AUDIO_NFT,
              );
            }),
      );
      await tester.pump();
      final imageWidget = find.byKey(const Key(kAudioWidgetKey));
      expect(imageWidget, findsOneWidget);
    });

    testWidgets("do pdf nft is showing to user or not", (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_PDF_NFT);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.collapsed).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        OwnerView(
          nft: MOCK_PRICED_PDF_NFT,
        ),
      );
      await tester.pump();
      final imageWidget = find.byKey(const Key(kPdfWidgetKey));
      expect(imageWidget, findsOneWidget);
    });

    testWidgets("do 3d model nft is showing to user or not", (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_3D_NFT);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.collapsed).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        OwnerView(
          nft: MOCK_PRICED_3D_NFT,
        ),
      );
      await tester.pump();
      final imageWidget = find.byKey(const Key(k3DWidgetKey));
      expect(imageWidget, findsOneWidget);
    });
  });
  testWidgets("do bottom sheet opens when user taps on open sheet icon", (tester) async {
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_NFT);
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
    when(viewModel.collapsed).thenAnswer((realInvocation) => true);
    await tester.testAppForWidgetTesting(
      OwnerView(
        nft: MOCK_PRICED_NFT,
      ),
    );
    await tester.pump();
    final keyboardUpIcon = find.byKey(const Key(kKeyboardArrowUpKey));
    when(viewModel.collapsed).thenAnswer((realInvocation) => false);
    await tester.tap(keyboardUpIcon);
    await tester.pump();
    expect(viewModel.collapsed, false);
  });

  testWidgets("do bottom sheet close when user taps on close sheet icon", (tester) async {
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_NFT);
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
    when(viewModel.collapsed).thenAnswer((realInvocation) => false);
    when(viewModel.viewCount).thenAnswer((realInvocation) => 4);
    when(viewModel.owner).thenAnswer((realInvocation) => MOCK_PRICED_NFT.owner);
    when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => false);
    await tester.testAppForWidgetTesting(
      OwnerView(
        nft: MOCK_PRICED_NFT,
      ),
    );
    await tester.pump();
    final keyboardDownIcon = find.byKey(const Key(kKeyboardArrowDownKey));
    when(viewModel.collapsed).thenAnswer((realInvocation) => true);
    await tester.tap(keyboardDownIcon);
    await tester.pump();
    expect(viewModel.collapsed, true);
  });

  testWidgets("can user tap on wallpaper icon to set wallpaper", (tester) async {
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_NFT);
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
    when(viewModel.collapsed).thenAnswer((realInvocation) => false);
    when(viewModel.viewCount).thenAnswer((realInvocation) => 4);
    when(viewModel.owner).thenAnswer((realInvocation) => MOCK_PRICED_NFT.owner);
    when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => false);
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester.testAppForWidgetTesting(
      OwnerView(
        nft: MOCK_PRICED_NFT,
      ),
    );
    await tester.pump();
    final wallpaperButtonKey = find.byKey(const Key(kWallpaperButtonKey));
    final wallpaperScreenKey = find.byKey(const Key(kWallpaperScreenKey));
    await tester.tap(wallpaperButtonKey);
    await tester.pump();
    expect(wallpaperScreenKey, findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets("can user set wallpaper on iOS", (tester) async {
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_NFT);
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
    when(viewModel.collapsed).thenAnswer((realInvocation) => false);
    when(viewModel.viewCount).thenAnswer((realInvocation) => 4);
    when(viewModel.owner).thenAnswer((realInvocation) => MOCK_PRICED_NFT.owner);
    when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => false);
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await tester.testAppForWidgetTesting(
      OwnerView(
        nft: MOCK_PRICED_NFT,
      ),
    );
    await tester.pump();
    final wallpaperButtonKey = find.byKey(const Key(kWallpaperButtonKey));
    expect(wallpaperButtonKey, findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets("can user set wallpaper on Android", (tester) async {
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_NFT);
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
    when(viewModel.collapsed).thenAnswer((realInvocation) => false);
    when(viewModel.viewCount).thenAnswer((realInvocation) => 4);
    when(viewModel.owner).thenAnswer((realInvocation) => MOCK_PRICED_NFT.owner);
    when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => false);
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester.testAppForWidgetTesting(
      OwnerView(
        nft: MOCK_PRICED_NFT,
      ),
    );
    await tester.pump();
    final wallpaperButtonKey = find.byKey(const Key(kWallpaperButtonKey));
    expect(wallpaperButtonKey, findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets("can user get set wallpaper icon in case of video", (tester) async {
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_Video_NFT);
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
    when(viewModel.collapsed).thenAnswer((realInvocation) => false);
    when(viewModel.viewCount).thenAnswer((realInvocation) => 4);
    when(viewModel.owner).thenAnswer((realInvocation) => MOCK_PRICED_Video_NFT.owner);
    when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
    when(easelViewModel.isVideoLoading).thenAnswer((realInvocation) => false);
    when(easelViewModel.videoLoadingError).thenAnswer((realInvocation) => '');
    when(easelViewModel.videoPlayerController).thenAnswer((realInvocation) => VideoPlayerController.network(MOCK_PRICED_Video_NFT.url));
    when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => false);
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester.testAppForWidgetTesting(
      ChangeNotifierProvider.value(
          value: GetIt.I.get<EaselProvider>(),
          builder: (context, child) {
            return OwnerView(
              nft: MOCK_PRICED_Video_NFT,
            );
          }),
    );
    await tester.pump();
    final wallpaperButtonKey = find.byKey(const Key(kWallpaperButtonKey));
    expect(wallpaperButtonKey, findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets("can user get set wallpaper icon in case of audio", (tester) async {
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_AUDIO_NFT);
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
    when(viewModel.collapsed).thenAnswer((realInvocation) => false);
    when(easelViewModel.collapsed).thenAnswer((realInvocation) => false);
    when(viewModel.viewCount).thenAnswer((realInvocation) => 4);
    when(viewModel.owner).thenAnswer((realInvocation) => MOCK_PRICED_AUDIO_NFT.owner);
    when(easelViewModel.buttonNotifier).thenAnswer((realInvocation) => ValueNotifier(ButtonState.playing));
    when(easelViewModel.audioProgressNotifier).thenAnswer(
      (realInvocation) => ValueNotifier(
        ProgressBarState(
          current: const Duration(seconds: 4),
          buffered: const Duration(seconds: 1),
          total: const Duration(seconds: 10),
        ),
      ),
    );
    when(easelViewModel.initializeAudioPlayer(publishedNFTUrl: MOCK_PRICED_AUDIO_NFT.url)).thenAnswer((realInvocation) async {
      return true;
    });
    when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => false);
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester.testAppForWidgetTesting(
      ChangeNotifierProvider.value(
          value: GetIt.I.get<EaselProvider>(),
          builder: (context, child) {
            return OwnerView(
              nft: MOCK_PRICED_AUDIO_NFT,
            );
          }),
    );
    await tester.pump();
    final wallpaperButtonKey = find.byKey(const Key(kWallpaperButtonKey));
    expect(wallpaperButtonKey, findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets("can user get set wallpaper icon in case of pdf", (tester) async {
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_PDF_NFT);
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
    when(viewModel.collapsed).thenAnswer((realInvocation) => false);
    when(viewModel.viewCount).thenAnswer((realInvocation) => 4);
    when(viewModel.owner).thenAnswer((realInvocation) => MOCK_PRICED_PDF_NFT.owner);
    when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => false);
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester.testAppForWidgetTesting(OwnerView(
      nft: MOCK_PRICED_PDF_NFT,
    ));
    await tester.pump();
    final wallpaperButtonKey = find.byKey(const Key(kWallpaperButtonKey));
    expect(wallpaperButtonKey, findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets("can user get set wallpaper icon in case of 3d model", (tester) async {
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_PRICED_3D_NFT);
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
    when(viewModel.collapsed).thenAnswer((realInvocation) => false);
    when(viewModel.viewCount).thenAnswer((realInvocation) => 4);
    when(viewModel.owner).thenAnswer((realInvocation) => MOCK_PRICED_3D_NFT.owner);
    when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => false);
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester.testAppForWidgetTesting(OwnerView(
      nft: MOCK_PRICED_3D_NFT,
    ));
    await tester.pump();
    final wallpaperButtonKey = find.byKey(const Key(kWallpaperButtonKey));
    expect(wallpaperButtonKey, findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets("can user get set wallpaper icon in case of image", (tester) async {
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT);
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
    when(viewModel.collapsed).thenAnswer((realInvocation) => false);
    when(viewModel.viewCount).thenAnswer((realInvocation) => 4);
    when(viewModel.owner).thenAnswer((realInvocation) => MOCK_NFT.owner);
    when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
    when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => false);
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester.testAppForWidgetTesting(OwnerView(
      nft: MOCK_NFT,
    ));
    await tester.pump();
    final wallpaperButtonKey = find.byKey(const Key(kWallpaperButtonKey));
    expect(wallpaperButtonKey, findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });
}
