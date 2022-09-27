import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_screen.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/audio_player_helper.dart';
import 'package:pylons_wallet/services/third_party_services/share_helper.dart';
import 'package:pylons_wallet/services/third_party_services/video_player_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';

import '../../../mocks/mock_audio_player.dart';
import '../../../mocks/mock_constants.dart';
import '../../../mocks/mock_repository.dart';
import '../../../mocks/mock_share_helper.dart';
import '../../../mocks/mock_video_player.dart';
import '../../../mocks/mock_wallet_store.dart';
import '../../extension/size_extension.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Repository repositry;
  late WalletsStore walletStore;
  late AudioPlayerHelper audioPlayerHelper;
  late VideoPlayerHelper videoPlayerHelper;
  late ShareHelper shareHelper;

  audioPlayerHelper = MockAudioPlayerImpl();
  videoPlayerHelper = MockVideoPlayerimpl();
  repositry = MockRepository();
  walletStore = MockWalletStore();
  shareHelper = MockShareHelperImpl();
  final PurchaseItemViewModel viewModel = PurchaseItemViewModel(
    walletStore,
    audioPlayerHelper: audioPlayerHelper,
    videoPlayerHelper: videoPlayerHelper,
    repository: repositry,
    shareHelper: shareHelper,
  );

  testWidgets("check buy button is in expanded view or not", (tester) async {
    await tester.testAppForWidgetTesting(
      ChangeNotifierProvider<PurchaseItemViewModel>.value(
        value: viewModel,
        child: PurchaseItemScreen(
          purchaseItemViewModel: viewModel,
        ),
      ),
    );
    viewModel.collapsed = true;
    viewModel.nft.quantity = MOCK_NFT_QUANTITY;
    viewModel.nft.amountMinted = MOCK_NFT_MINTED;
    await tester.pump();
    final keyboardUpButtonFinder = find.byKey(const Key(kKeyboardUpButtonKeyValue));
    await tester.tap(keyboardUpButtonFinder);
    await tester.pumpAndSettle();
    final expandedBuyButtonFinder = find.byKey(const Key(kExpandedBuyButtonKeyValue));
    expect(expandedBuyButtonFinder, findsOneWidget);
  });
}
