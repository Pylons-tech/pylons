import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/pages/owner_purchase_view_common/button_state.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/audio_player_helper.dart';
import 'package:pylons_wallet/services/third_party_services/share_helper.dart';
import 'package:pylons_wallet/services/third_party_services/video_player_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../mocks/audio_Player.mocks.dart';
import '../../mocks/mock_audio_player.dart';
import '../../mocks/mock_constants.dart';
import '../../mocks/mock_repository.dart';
import '../../mocks/mock_share_helper.dart';
import '../../mocks/mock_video_player.dart';
import '../../mocks/mock_wallet_store.dart';
import '../../mocks/video_player.mocks.dart';
import '../extension/size_extension.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late OwnerViewViewModel viewModel;
  late MockVideoPlayerController videoPlayerController;
  late AudioPlayer audioPlayer;
  late Repository repository;
  late WalletsStore walletStore;
  late AudioPlayerHelper audioPlayerHelper;
  late ShareHelper shareHelper;
  late VideoPlayerHelper videoPlayerHelper;

  audioPlayer = MockAudioPlayer();
  videoPlayerController = MockVideoPlayerController();
  repository = MockRepository();
  walletStore = MockWalletStore();
  audioPlayerHelper = MockAudioPlayerImpl(audioPlayer);
  shareHelper = MockShareHelperImpl();
  videoPlayerHelper = MockVideoPlayerImpl(videoPlayerController);
  GetIt.I.registerLazySingleton<WalletsStore>(() => walletStore);
  viewModel = OwnerViewViewModel(
    repository: repository,
    walletsStore: walletStore,
    audioPlayerHelper: audioPlayerHelper,
    shareHelper: shareHelper,
    videoPlayerHelper: videoPlayerHelper,
  );
  GetIt.I.registerLazySingleton(() => viewModel);

  ///Defines Stub for audio player & video player

  registerStubs(audioPlayerHelper, viewModel, videoPlayerController);

  testWidgets(
    "Audio stops while sharing NFT",
    (tester) async {
      await tester.testAppForWidgetTesting(
        OwnerView(
          nft: MOCK_NFT_FREE_AUDIO,
        ),
      );
      final shareNftButton = find.byKey(const Key(kShareNftButtonCollapsedKey));
      await tester.ensureVisible(shareNftButton);
      await tester.pump();
      viewModel.playAudio();
      await tester.tap(shareNftButton);
      expect(viewModel.buttonNotifier.value, ButtonState.paused);
    },
  );

  testWidgets(
    "Video stops while sharing NFT",
    (tester) async {
      await tester.testAppForWidgetTesting(
        OwnerView(
          nft: MOCK_NFT_FREE_VIDEO,
        ),
      );
      final shareNftButton = find.byKey(const Key(kShareNftButtonCollapsedKey));
      await tester.ensureVisible(shareNftButton);
      await tester.pump(const Duration(seconds: 4));
      await tester.tap(shareNftButton);
      expect(viewModel.videoPlayerController!.value.isPlaying, false);
    },
  );
}

void registerStubs(AudioPlayerHelper audioPlayerHelper, OwnerViewViewModel viewModel, MockVideoPlayerController videoPlayerController) {
  when(audioPlayerHelper.playerStateStream()).thenAnswer((realInvocation) async* {
    yield PlayerState(true, ProcessingState.ready);
  });
  when(audioPlayerHelper.pauseAudio()).thenAnswer((realInvocation) async {
    viewModel.buttonNotifier.value = ButtonState.paused;
  });

  when(videoPlayerController.initialize()).thenAnswer(
    (realInvocation) async {
      viewModel.videoPlayerController!.value = VideoPlayerValue(
        duration: const Duration(
          minutes: 2,
        ),
        isPlaying: true,
      );
    },
  );

  when(videoPlayerController.pause()).thenAnswer(
    (realInvocation) async {
      viewModel.videoPlayerController!.value = VideoPlayerValue(
        duration: const Duration(
          minutes: 2,
        ),
      );
    },
  );
}
