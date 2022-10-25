import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/pay_now_dialog.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import '../../../../mocks/mock_constants.dart';
import '../../../helpers/size_extensions.dart';

void main() {
  testWidgets('should find secondary pylon currency Icon', (tester) async {
    final nft = MOCK_NFT_PREMIUM;
    await tester.testAppForWidgetTesting(Material(child: PayNowWidget(nft: nft, onPurchaseDone: (_) {}, shouldBuy: false)));
    final findSecondaryPylonIcon = find.image(AssetImage(ImageUtil.PYLONS_CURRENCY_TRANSPARENT));
    expect(findSecondaryPylonIcon, findsOneWidget);
  });
}
