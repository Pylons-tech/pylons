import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_screen.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/pages/purchase_item/viewmodel/accept_policy_viewmodel.dart';
import 'package:pylons_wallet/utils/constants.dart';
import '../../../../mocks/accept_policy_viewmodel.mocks.dart';
import '../../../../mocks/mock_constants.dart';
import '../../../../mocks/purchase_item_view_model.mocks.dart';
import '../../../extension/size_extension.dart';

void main() {
  final purchaseItemViewModel = MockPurchaseItemViewModel();
  final acceptPolicyViewModel = MockAcceptPolicyViewModel();
  GetIt.I.registerLazySingleton<PurchaseItemViewModel>(() => purchaseItemViewModel);
  GetIt.I.registerLazySingleton<AcceptPolicyViewModel>(() => acceptPolicyViewModel);

  testWidgets(
    "is accept policy bottom sheet showing",
    (tester) async {
      when(purchaseItemViewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_IMAGE);
      when(purchaseItemViewModel.getUserAcceptPolicies()).thenAnswer((realInvocation) => false);
      await tester.testAppForWidgetTesting(
        PurchaseItemScreen(
          nft: MOCK_NFT_FREE_IMAGE,
        ),
      );
      await tester.pumpAndSettle();
      final kBottomSheetKey = find.byKey(const Key(kAcceptBottomSheetKey));
      expect(kBottomSheetKey, findsOneWidget);
    },
  );

  testWidgets(
    "is accept policy bottom sheet not showing",
    (tester) async {
      when(purchaseItemViewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_IMAGE);
      when(purchaseItemViewModel.getUserAcceptPolicies()).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        PurchaseItemScreen(
          nft: MOCK_NFT_FREE_IMAGE,
        ),
      );
      await tester.pumpAndSettle();
      final kBottomSheetKey = find.byKey(const Key(kAcceptBottomSheetKey));
      expect(kBottomSheetKey, findsNothing);
    },
  );

  testWidgets(
    "can user tap on get started button to accept policies",
    (tester) async {
      when(purchaseItemViewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_IMAGE);
      when(purchaseItemViewModel.getUserAcceptPolicies()).thenAnswer((realInvocation) => false);
      when(purchaseItemViewModel.setUserAcceptPolicies()).thenAnswer((realInvocation) => true);
      when(acceptPolicyViewModel.isCheckPrivacyPolicy).thenAnswer((realInvocation) => true);
      when(acceptPolicyViewModel.isCheckTermServices).thenAnswer((realInvocation) => true);
      await tester.testAppForWidgetTesting(
        PurchaseItemScreen(
          nft: MOCK_NFT_FREE_IMAGE,
        ),
      );
      await tester.pumpAndSettle();
      final kBottomSheetKey = find.byKey(const Key(kAcceptBottomSheetKey));
      final kBottomSheetBtnKey = find.byKey(const Key(kAcceptBottomSheetBtnKey));
      expect(kBottomSheetKey, findsOneWidget);
      await tester.tap(kBottomSheetBtnKey);
      await tester.pumpAndSettle();
      expect(kBottomSheetKey, findsNothing);
    },
  );
}
