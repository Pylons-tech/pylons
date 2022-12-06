import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/owner_purchase_view_common/button_state.dart';
import 'package:pylons_wallet/pages/owner_purchase_view_common/progress_bar_state.dart';
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

  testWidgets(
    "Image file extension should show to user",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_IMAGE);
      when(viewModel.collapsed).thenAnswer((realInvocation) => false);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider.value(
            value: viewModel,
            builder: (context, child) {
              return PurchaseItemScreen(
                nft: MOCK_NFT_FREE_IMAGE,
              );
            }),
      );
      await tester.pump();
      expect(find.text('${MOCK_NFT_FREE_IMAGE.width}x${MOCK_NFT_FREE_IMAGE.height} ${MOCK_NFT_FREE_IMAGE.fileExtension}'), findsOneWidget);
    },
  );

  testWidgets(
    "Video file extension should show to user",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_VIDEO);
      when(viewModel.collapsed).thenAnswer((realInvocation) => false);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider.value(
            value: viewModel,
            builder: (context, child) {
              return PurchaseItemScreen(
                nft: MOCK_NFT_FREE_VIDEO,
              );
            }),
      );
      await tester.pump();
      expect(find.text('${MOCK_NFT_FREE_VIDEO.width}x${MOCK_NFT_FREE_VIDEO.height} ${MOCK_NFT_FREE_VIDEO.fileExtension}'), findsOneWidget);
    },
  );

  testWidgets(
    "Audio file extension should show to user",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_AUDIO);
      when(viewModel.collapsed).thenAnswer((realInvocation) => false);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => true);
      when(viewModel.buttonNotifier).thenAnswer((realInvocation) => ValueNotifier(ButtonState.playing));
      when(viewModel.progressNotifier).thenAnswer(
        (realInvocation) => ValueNotifier(
          ProgressBarState(
            current: const Duration(
              seconds: 50,
            ),
            buffered: const Duration(
              seconds: 10,
            ),
            total: const Duration(minutes: 2),
          ),
        ),
      );
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider.value(
            value: viewModel,
            builder: (context, child) {
              return PurchaseItemScreen(
                nft: MOCK_NFT_FREE_AUDIO,
              );
            }),
      );
      await tester.pump();
      expect(find.text('${MOCK_NFT_FREE_AUDIO.width}x${MOCK_NFT_FREE_AUDIO.height} ${MOCK_NFT_FREE_AUDIO.fileExtension}'), findsOneWidget);
    },
  );

  testWidgets(
    "3D file extension should show to user",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_3D);
      when(viewModel.collapsed).thenAnswer((realInvocation) => false);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider.value(
            value: viewModel,
            builder: (context, child) {
              return PurchaseItemScreen(
                nft: MOCK_NFT_FREE_3D,
              );
            }),
      );
      await tester.pump();
      expect(find.text('${MOCK_NFT_FREE_3D.width}x${MOCK_NFT_FREE_3D.height} ${MOCK_NFT_FREE_3D.fileExtension}'), findsOneWidget);
    },
  );

  testWidgets(
    "Pdf file extension should show to user",
    (tester) async {
      when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_PDF);
      when(viewModel.collapsed).thenAnswer((realInvocation) => false);
      when(viewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(viewModel.isHistoryExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isOwnershipExpanded).thenAnswer((realInvocation) => false);
      when(viewModel.isDetailsExpanded).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider.value(
            value: viewModel,
            builder: (context, child) {
              return PurchaseItemScreen(
                nft: MOCK_NFT_FREE_PDF,
              );
            }),
      );
      await tester.pump();
      expect(find.text('${MOCK_NFT_FREE_PDF.width}x${MOCK_NFT_FREE_PDF.height} ${MOCK_NFT_FREE_PDF.fileExtension}'), findsOneWidget);
    },
  );
}
