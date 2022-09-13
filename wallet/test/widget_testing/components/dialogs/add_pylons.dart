import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/pay_now_dialog.dart';

import '../../helpers/size_extensions.dart';

Dialog? showBuyDialog({required BuildContext context, required Dialog buyDialog, required bool dismissible}) {
  showDialog(
    barrierDismissible: dismissible,
    context: context,
    builder: (BuildContext context) {
      return buyDialog;
    },
  );
  return null;
}

void main() {
  final nft = NFT(ibcCoins: IBCCoins.upylon);
  testWidgets('should test whether add pylons points dialog Button is working as expected or not', (WidgetTester tester) async {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    await tester.testAppForWidgetTesting(MaterialApp(home: Scaffold(key: scaffoldKey)));

    final widgetFinder = find.text("add_pylons".tr());

    showBuyDialog(
        context: scaffoldKey.currentContext!,
        buyDialog: Dialog(
          backgroundColor: Colors.transparent,
          child: PayNowWidget(
            nft: nft,
            onPurchaseDone: (value) {},
            shouldBuy: false,
          ),
        ),
        dismissible: true);

    await tester.pump();
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should test whether swipe to purchase Button is working as expected or not', (WidgetTester tester) async {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    await tester.testAppForWidgetTesting(MaterialApp(home: Scaffold(key: scaffoldKey)));

    final widgetFinder = find.text("swipe_right_to_pay".tr());

    showBuyDialog(
        context: scaffoldKey.currentContext!,
        buyDialog: Dialog(
          backgroundColor: Colors.transparent,
          child: PayNowWidget(
            nft: nft,
            onPurchaseDone: (value) {},
            shouldBuy: true,
          ),
        ),
        dismissible: true);

    await tester.pump();
    expect(widgetFinder, findsOneWidget);
  });
}
