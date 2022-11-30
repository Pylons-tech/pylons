import 'dart:io';

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
}
