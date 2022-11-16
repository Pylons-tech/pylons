import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/audio_player_helper.dart';
import 'package:pylons_wallet/services/third_party_services/share_helper.dart';
import 'package:pylons_wallet/services/third_party_services/video_player_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import '../../mocks/mock_constants.dart';
import '../../mocks/mock_repository.dart';
import '../../mocks/mock_share_helper.dart';
import '../../mocks/mock_wallet_store.dart';
import '../../mocks/mock_video_player.dart';
import '../../mocks/mock_audio_player.dart';
import '../extension/size_extension.dart';


/// TODO: Add test for the account public info shown

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    late Repository repositry;
    late WalletsStore walletStore;
    late AudioPlayerHelper audioPlayerHelper;
    late VideoPlayerHelper videoPlayerHelper;
    late ShareHelper shareHelper;
    audioPlayerHelper = MockAudioPlayerImpl();
    videoPlayerHelper = MockVideoPlayerImpl();
    repositry = MockRepository();
    walletStore = MockWalletStore();
    shareHelper = MockShareHelperImpl();
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
  });

  testWidgets('test case for gestures', (tester) async {
    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(OwnerView(
      nft: MOCK_NFT_FREE_IMAGE,
    ));
    await tester.pumpAndSettle();
    final gestureDetectorOwnerScreen = find.byKey(const ValueKey(kOwnerViewKeyValue));
    final ownerViewHeader = find.byKey(const ValueKey(kOwnerViewDrawerKeyValue));
    await tester.ensureVisible(gestureDetectorOwnerScreen);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(ownerViewHeader, findsOneWidget);
  });
}
