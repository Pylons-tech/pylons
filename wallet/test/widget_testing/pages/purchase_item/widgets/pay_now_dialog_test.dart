import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/pay_now_dialog.dart';

import '../../../../mocks/mock_constants.dart';
import '../../../helpers/size_extensions.dart';

void main() {
  testWidgets('Should show swipe to pay button', (tester) async {
    final nft = MOCK_NFT_PREMIUM;
    await tester.testAppForWidgetTesting(Material(child: PayNowWidget(nft: nft, onPurchaseDone: (_) {}, shouldBuy: true)));
    final findSwipeToPayButton = find.text('swipe_right_to_pay'.tr());
    expect(findSwipeToPayButton, findsOneWidget);
  });

  testWidgets('Should show add points button', (tester) async {
    final nft = MOCK_NFT_PREMIUM;
    await tester.testAppForWidgetTesting(Material(child: PayNowWidget(nft: nft, onPurchaseDone: (_) {}, shouldBuy: false)));
    final findAddPointsButton = find.text("add_pylons".tr());
    expect(findAddPointsButton, findsOneWidget);
  });
}
