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
import 'package:easy_localization/easy_localization.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/buy_nft_button.dart';


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

  testWidgets('should show the Free Drop NFT Buy Button and make sure user is able to tap', (tester) async {
    final buyButtonFinder = find.text("claim_free_nft".tr());
    var isTapped = false;

    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(Material(
      child: BuyNFTButton(
        onTapped: () {
          isTapped = true;
        },
        nft: MOCK_NFT_FREE,
      ),
    ));

    expect(buyButtonFinder, findsOneWidget);
    await tester.tap(buyButtonFinder);

    expect(true, isTapped);
  });


  testWidgets('should show the NFT Buy Button and make sure user is able to tap', (tester) async {
    final buyButtonFinder = find.text("${"buy_for".tr()} ${MOCK_NFT_PREMIUM.ibcCoins.getCoinWithProperDenomination(MOCK_NFT_PREMIUM.price)}");
    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(Material(
      child: BuyNFTButton(
        onTapped: () {},
        nft: MOCK_NFT_PREMIUM,
      ),
    ));

    expect(buyButtonFinder, findsOneWidget);
  });


}
