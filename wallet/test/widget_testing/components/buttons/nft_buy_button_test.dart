import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../mocks/mock_constants.dart';
import '../../extension/size_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/buy_nft_button.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
