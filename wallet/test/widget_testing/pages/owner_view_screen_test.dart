import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/pages/owner_purchase_view_common/button_state.dart';
import 'package:pylons_wallet/pages/owner_purchase_view_common/progress_bar_state.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../mocks/mock_constants.dart';
import '../../mocks/mock_wallet_store.dart';
import '../../mocks/test_mocks.mocks.dart';
import '../extension/size_extension.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final walletStore = MockWalletStore();
  GetIt.I.registerLazySingleton<WalletsStore>(() => walletStore);
  final viewModel = MockOwnerViewViewModel();
  GetIt.I.registerLazySingleton<OwnerViewViewModel>(() => viewModel);

  registerStubs(viewModel);

  testWidgets(
    "Audio should stops when sharing nft",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => viewModel.nft = MOCK_NFT_FREE_AUDIO);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);

      await tester.testAppForWidgetTesting(
        OwnerView(
          nft: MOCK_NFT_FREE_AUDIO,
        ),
      );
      final shareNftButton = find.byKey(const Key(kShareNftButtonCollapsedKey));
      await tester.ensureVisible(shareNftButton);
      await tester.pump();
      await tester.tap(shareNftButton);
      await tester.pump();
      expect(viewModel.buttonNotifier.value, ButtonState.paused);
    },
  );

  testWidgets(
    "Video should stops when sharing nft",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => viewModel.nft = MOCK_NFT_FREE_VIDEO);
      when(viewModel.isVideoLoading).thenAnswer((realInvocation) => false);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.videoLoadingError).thenAnswer((realInvocation) => '');


      await tester.testAppForWidgetTesting(
        OwnerView(
          nft: MOCK_NFT_FREE_VIDEO,
        ),
      );
      final shareNftButton = find.byKey(const Key(kShareNftButtonCollapsedKey));
      await tester.ensureVisible(shareNftButton);
      await tester.pump(const Duration(seconds: 4));
      await tester.tap(shareNftButton);
      await tester.pump();
      expect(viewModel.videoPlayerController!.value.isPlaying, false);
    },
  );

  testWidgets(
    "Image file extension should show to user",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_IMAGE);
      when(viewModel.collapsed).thenAnswer((realInvocation) => false);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.viewsCount).thenAnswer((realInvocation) => 0);
      when(viewModel.owner).thenAnswer((realInvocation) => '');
      when(viewModel.isLiking).thenAnswer((realInvocation) => false);
      when(viewModel.likesCount).thenAnswer((realInvocation) => 0);
      when(viewModel.likedByMe).thenAnswer((realInvocation) => false);
      when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => true);
      when(viewModel.isNFTEnabled()).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider.value(
          value: viewModel,
          builder: (context, child) {
            return OwnerView(
              nft: MOCK_NFT_FREE_IMAGE,
            );
          },
        ),
      );
      await tester.pump();
      expect(
        find.text(
            '${MOCK_NFT_FREE_IMAGE.width}x${MOCK_NFT_FREE_IMAGE.height} ${MOCK_NFT_FREE_IMAGE.fileExtension.toUpperCase()}'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Video file extension should show to user",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_VIDEO);
      when(viewModel.collapsed).thenAnswer((realInvocation) => false);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isVideoLoading).thenAnswer((realInvocation) => false);
      when(viewModel.videoLoadingError).thenAnswer((realInvocation) => '');
      when(viewModel.viewsCount).thenAnswer((realInvocation) => 0);
      when(viewModel.owner).thenAnswer((realInvocation) => '');
      when(viewModel.likedByMe).thenAnswer((realInvocation) => false);
      when(viewModel.isLiking).thenAnswer((realInvocation) => false);
      when(viewModel.likesCount).thenAnswer((realInvocation) => 0);
      when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => true);
      when(viewModel.isNFTEnabled()).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider.value(
            value: viewModel,
            builder: (context, child) {
              return OwnerView(
                nft: MOCK_NFT_FREE_VIDEO,
              );
            }),
      );
      await tester.pump();
      expect(find.text('${MOCK_NFT_FREE_VIDEO.width}x${MOCK_NFT_FREE_VIDEO.height} ${MOCK_NFT_FREE_VIDEO.fileExtension.toUpperCase()}'), findsOneWidget);
    },
  );

  testWidgets(
    "Audio file extension should show to user",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_AUDIO);
      when(viewModel.collapsed).thenAnswer((realInvocation) => false);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.viewsCount).thenAnswer((realInvocation) => 0);
      when(viewModel.owner).thenAnswer((realInvocation) => '');
      when(viewModel.isLiking).thenAnswer((realInvocation) => false);
      when(viewModel.likedByMe).thenAnswer((realInvocation) => false);
      when(viewModel.likesCount).thenAnswer((realInvocation) => 0);
      when(viewModel.isNFTEnabled()).thenAnswer((realInvocation) => true);
      when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider.value(
            value: viewModel,
            builder: (context, child) {
              return OwnerView(
                nft: MOCK_NFT_FREE_AUDIO,
              );
            }),
      );
      await tester.pump();
      expect(find.text('${MOCK_NFT_FREE_AUDIO.width}x${MOCK_NFT_FREE_AUDIO.height} ${MOCK_NFT_FREE_AUDIO.fileExtension.toUpperCase()}'), findsOneWidget);
    },
  );

  testWidgets(
    "3D file extension should show to user",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_3D);
      when(viewModel.collapsed).thenAnswer((realInvocation) => false);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.viewsCount).thenAnswer((realInvocation) => 0);
      when(viewModel.owner).thenAnswer((realInvocation) => '');
      when(viewModel.isLiking).thenAnswer((realInvocation) => false);
      when(viewModel.likesCount).thenAnswer((realInvocation) => 0);
      when(viewModel.isNFTEnabled()).thenAnswer((realInvocation) => true);
      when(viewModel.likedByMe).thenAnswer((realInvocation) => false);
      when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider.value(
            value: viewModel,
            builder: (context, child) {
              return OwnerView(
                nft: MOCK_NFT_FREE_3D,
              );
            }),
      );
      await tester.pump();
      expect(find.text('${MOCK_NFT_FREE_3D.width}x${MOCK_NFT_FREE_3D.height} ${MOCK_NFT_FREE_3D.fileExtension.toUpperCase()}'), findsOneWidget);
    },
  );

  testWidgets(
    "Pdf file extension should show to user",
        (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_PDF);
      when(viewModel.collapsed).thenAnswer((realInvocation) => false);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => true);
      when(viewModel.viewsCount).thenAnswer((realInvocation) => 0);
      when(viewModel.owner).thenAnswer((realInvocation) => '');
      when(viewModel.isLiking).thenAnswer((realInvocation) => false);
      when(viewModel.likesCount).thenAnswer((realInvocation) => 0);
      when(viewModel.isNFTEnabled()).thenAnswer((realInvocation) => true);
      when(viewModel.likedByMe).thenAnswer((realInvocation) => false);
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider.value(
            value: viewModel,
            builder: (context, child) {
              return OwnerView(
                nft: MOCK_NFT_FREE_PDF,
              );
            }),
      );
      await tester.pump();
      expect(find.text('${MOCK_NFT_FREE_PDF.width}x${MOCK_NFT_FREE_PDF.height} ${MOCK_NFT_FREE_PDF.fileExtension.toUpperCase()}'), findsOneWidget);
    },
  );
}

void registerStubs(OwnerViewViewModel viewModel) {
  ///Defines Stub for audio player
  when(viewModel.buttonNotifier).thenAnswer((realInvocation) => ValueNotifier(ButtonState.paused));
  when(viewModel.audioProgressNotifier).thenAnswer(
    (realInvocation) => ValueNotifier(
      ProgressBarState(
        current: const Duration(
          seconds: 50,
        ),
        buffered: const Duration(
          seconds: 10,
        ),
        total: const Duration(minutes: 2),
      ),
    ),
  );
  when(viewModel.collapsed).thenAnswer((realInvocation) {
    return true;
  });
  when(viewModel.pauseAudio()).thenAnswer((realInvocation) async {
    viewModel.buttonNotifier.value = ButtonState.paused;
  });

  ///Defines Stub for video player

  when(viewModel.videoPlayerController).thenAnswer((realInvocation) {
    final VideoPlayerController controller;
    controller = VideoPlayerController.network(MOCK_URL);
    controller.value = VideoPlayerValue(
      duration: const Duration(
        minutes: 2,
      ),
    );
    return controller;
  });
  when(viewModel.collapsed).thenAnswer((realInvocation) => true);
  when(viewModel.shareNFTLink(size: const Size(10, 10))).thenAnswer((realInvocation) async {
    viewModel.videoPlayerController!.value = VideoPlayerValue(
      duration: const Duration(
        minutes: 2,
      ),
    );
  });
}
