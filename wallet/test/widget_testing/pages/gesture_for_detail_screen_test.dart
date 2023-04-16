// ignore_for_file: void_checks

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/services/third_party_services/audio_player_helper.dart';
import 'package:pylons_wallet/services/third_party_services/share_helper.dart';
import 'package:pylons_wallet/services/third_party_services/video_player_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import '../../mocks/main_mock.mocks.dart';
import '../../mocks/mock_constants.dart';
import '../../mocks/mock_video_player.dart';
import '../../mocks/mock_audio_player.dart';
import '../../test_utils/flutter_test_extender.dart';
import '../extension/size_extension.dart';

void main() {
  group("Gesture", () {
    TestWidgetsFlutterBinding.ensureInitialized();

    setUpWidgets((tester) async {
      late WalletsStore walletStore;
      late AudioPlayerHelper audioPlayerHelper;
      late VideoPlayerHelper videoPlayerHelper;
      late ShareHelper shareHelper;
      audioPlayerHelper = MockAudioPlayerImpl();
      videoPlayerHelper = MockVideoPlayerImpl();
      final repositry = MockRepository();
      walletStore = MockWalletsStore();
      shareHelper = MockShareHelper();
      final OwnerViewViewModel viewModel = OwnerViewViewModel(
          repository: repositry,
          walletsStore: walletStore,
          audioPlayerHelper: audioPlayerHelper,
          videoPlayerHelper: videoPlayerHelper,
          shareHelper: shareHelper,
          accountPublicInfo: const AccountPublicInfo(
            accountId: '',
            chainId: '',
            name: '',
            publicAddress: '',
          ));

      GetIt.I.registerSingleton(viewModel);

      when(repositry.logUserJourney(screenName: anyNamed("screenName"))).thenAnswer((_) async => const Right(""));
      when(repositry.ifLikedByMe(
        cookBookID: anyNamed("cookBookID"),
        recipeId: anyNamed("recipeId"),
        walletAddress: anyNamed("walletAddress"),
      )).thenAnswer((_) async => const Right(true));
      when(repositry.getLikesCount(cookBookID: anyNamed("cookBookID"), recipeId: anyNamed("recipeId")))
          .thenAnswer((_) async => const Right(0));

      when(repositry.countAView(
        cookBookID: anyNamed("cookBookID"),
        recipeId: anyNamed("recipeId"),
        walletAddress: anyNamed("walletAddress"),
      )).thenAnswer((_) async => const Right(0));

      when(repositry.getViewsCount(cookBookID: anyNamed("cookBookID"), recipeId: anyNamed("recipeId")))
          .thenAnswer((_) async => const Right(0));

      await tester.setScreenSize();
      await tester.testAppForWidgetTesting(OwnerView(
        nft: MOCK_NFT_FREE_IMAGE,
      ));
      await tester.pumpAndSettle();
      final gestureDetectorOwnerScreen = find.byKey(const ValueKey(kOwnerViewKeyValue));
      await tester.ensureVisible(gestureDetectorOwnerScreen);
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('test case for gestures', (tester) async {
      final ownerViewHeader = find.byKey(const ValueKey(kOwnerViewDrawerKeyValue));
      expect(ownerViewHeader, findsOneWidget);
    });
  });
}
