import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_screen.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';

import '../../../mocks/mock_constants.dart';
import '../../../mocks/mock_wallet_store.dart';
import '../../../mocks/purchase_item_view_model.mocks.dart';
import '../../extension/size_extension.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final WalletsStore walletStore = MockWalletStore();
  final PurchaseItemViewModel viewModel = MockPurchaseItemViewModel();
  GetIt.I.registerLazySingleton<WalletsStore>(() => walletStore);
  GetIt.I.registerLazySingleton<PurchaseItemViewModel>(() => viewModel);

  testWidgets("Purchase Item Screen Bottom Sheet Visibility Test", (tester) async {
    when(viewModel.collapsed).thenAnswer((realInvocation) => false);
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_IMAGE);
    when(viewModel.showBuyNowButton(isPlatformAndroid: Platform.isAndroid)).thenAnswer((realInvocation) => true);
    await tester.testAppForWidgetTesting(
      ChangeNotifierProvider<PurchaseItemViewModel>.value(
        value: viewModel,
        child: PurchaseItemScreen(
          nft: viewModel.nft,
        ),
      ),
    );
    await tester.pump();
    final bottomSheet = find.byKey(const Key(kPurchaseItemBottomSheetKey));
    expect(bottomSheet, findsOneWidget);
    final closeBottomSheetButton = find.byKey(const Key(kCloseBottomSheetKey));
    expect(closeBottomSheetButton, findsOneWidget);
  });

  testWidgets('double tap gesture to hide icons for purchase item screen', (tester) async {
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_PREMIUM);
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
    await tester.testAppForWidgetTesting(PurchaseItemScreen(
      nft: MOCK_NFT_PREMIUM,
    ));
    await tester.pump();
    final gestureWidget = find.byKey(const Key(kGestureDetailWidget));
    await tester.ensureVisible(gestureWidget);
    await tester.pumpAndSettle();
    await tester.tap(gestureWidget);
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(gestureWidget);
    await tester.pumpAndSettle();
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => true);
    expect(viewModel.isViewingFullNft, true);
  });


  testWidgets('double tap gesture to show icons for purchase item screen', (tester) async {
    when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_PREMIUM);
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => true);
    await tester.testAppForWidgetTesting(PurchaseItemScreen(
      nft: MOCK_NFT_PREMIUM,
    ));
    await tester.pump();
    final gestureWidget = find.byKey(const Key(kGestureDetailWidget));
    await tester.ensureVisible(gestureWidget);
    await tester.pumpAndSettle();
    await tester.tap(gestureWidget);
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(gestureWidget);
    await tester.pumpAndSettle();
    when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
    expect(viewModel.isViewingFullNft, false);
  });
}
