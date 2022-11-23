import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
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
import '../../mocks/owner_view_view_model.mocks.dart';
import '../extension/size_extension.dart';

@GenerateMocks([BuildContext])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late OwnerViewViewModel viewModel;
  late WalletsStore walletStore;
  walletStore = MockWalletStore();
  GetIt.I.registerLazySingleton<WalletsStore>(() => walletStore);
  viewModel = MockOwnerViewViewModel();
  GetIt.I.registerLazySingleton(() => viewModel);

  registerStubs(viewModel);

  testWidgets(
    "Audio should stops when sharing nft",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => viewModel.nft = MOCK_NFT_FREE_AUDIO);

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
    "For Sale toggle dialog test",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => viewModel.nft = MOCK_NFT_FREE_IMAGE);
      await tester.testAppForWidgetTesting(
        Scaffold(
          body: OwnerView(
            nft: MOCK_NFT_FREE_IMAGE,
          ),
        ),
      );

      final toggleButton = find.byKey(const Key(kSaleStatusToggleButtonKey));
      tester.ensureVisible(toggleButton);
      final enabledToggleIcon = find.byKey(const Key(kForSaleToggleWidgetKey));
      await tester.ensureVisible(enabledToggleIcon);
      await tester.tap(toggleButton);
      await tester.pump();
      final notForSaleDialog = find.byKey(const Key(kNotForSaleDialogKey));
      await tester.ensureVisible(notForSaleDialog);
    },
  );

  testWidgets(
    "Not For Sale toggle bottom sheet test",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => viewModel.nft = MOCK_DISABLED_NFT_IMAGE);
      await tester.testAppForWidgetTesting(
        Scaffold(
          body: OwnerView(
            nft: MOCK_DISABLED_NFT_IMAGE,
          ),
        ),
      );

      final toggleButton = find.byKey(const Key(kSaleStatusToggleButtonKey));
      tester.ensureVisible(toggleButton);
      final disabledToggleIcon = find.byKey(const Key(kNotForSaleToggleWidgetKey));
      await tester.ensureVisible(disabledToggleIcon);
      await tester.tap(toggleButton);
      await tester.pump();
      final forSaleBottomSheet = find.byKey(const Key(kForSaleBottomSheetKey));
      await tester.ensureVisible(forSaleBottomSheet);
    },
  );
}

void registerStubs(OwnerViewViewModel viewModel) {
  const MethodChannel channel = MethodChannel('vn.hunghd/downloader');
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    return "initialize";
  });
  FlutterDownloader.initialize();

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
