import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/pages/presenting_onboard_page/screens/accept_policy_screen.dart';
import 'package:pylons_wallet/pages/presenting_onboard_page/viewmodel/accept_policy_viewmodel.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_screen.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/utils/constants.dart';
import '../../../mocks/accept_policy_viewmodel.mocks.dart';
import '../../../mocks/mock_constants.dart';
import '../../../mocks/purchase_item_view_model.mocks.dart';
import '../../extension/size_extension.dart';

void main() {
  final acceptPolicyViewModel = MockAcceptPolicyViewModel();
  final purchaseItemViewModel = MockPurchaseItemViewModel();
  GetIt.I.registerLazySingleton<AcceptPolicyViewModel>(() => acceptPolicyViewModel);
  GetIt.I.registerLazySingleton<PurchaseItemViewModel>(() => purchaseItemViewModel);

  testWidgets(
    "is accept policy portion showing",
    (tester) async {
      await tester.testAppForWidgetTesting(
        AcceptPolicyScreen(
          nft: MOCK_NFT_FREE_IMAGE,
          viewModel: GetIt.I.get<AcceptPolicyViewModel>(),
        ),
      );
      await tester.pump();
      final kAcceptPolicyPortion = find.byKey(const Key(kAcceptPolicyPortionKey));
      expect(kAcceptPolicyPortion, findsOneWidget);
    },
  );

  testWidgets(
    "When the terms and conditions are not accepted then user cannot go to next screen.",
    (tester) async {
      when(acceptPolicyViewModel.isCheckPrivacyPolicy).thenAnswer((realInvocation) => true);
      when(acceptPolicyViewModel.isCheckTermServices).thenAnswer((realInvocation) => false);
      when(purchaseItemViewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_IMAGE);
      await tester.testAppForWidgetTesting(
        AcceptPolicyScreen(
          nft: MOCK_NFT_FREE_IMAGE,
          viewModel: GetIt.I.get<AcceptPolicyViewModel>(),
        ),
      );
      await tester.pump();
      final kBottomSheetBtnKey = find.byKey(const Key(kAcceptBottomSheetBtnKey));
      await tester.tap(kBottomSheetBtnKey);
      await tester.pump();
      expect(find.byType(PurchaseItemScreen), findsNothing);
    },
  );

  testWidgets(
    "When the privacy policy is not accepted then user cannot go to next screen.",
    (tester) async {
      when(acceptPolicyViewModel.isCheckPrivacyPolicy).thenAnswer((realInvocation) => false);
      when(acceptPolicyViewModel.isCheckTermServices).thenAnswer((realInvocation) => true);
      when(purchaseItemViewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_IMAGE);
      await tester.testAppForWidgetTesting(
        AcceptPolicyScreen(
          nft: MOCK_NFT_FREE_IMAGE,
          viewModel: GetIt.I.get<AcceptPolicyViewModel>(),
        ),
      );
      await tester.pump();
      final kBottomSheetBtnKey = find.byKey(const Key(kAcceptBottomSheetBtnKey));
      await tester.tap(kBottomSheetBtnKey);
      await tester.pump();
      expect(find.byType(PurchaseItemScreen), findsNothing);
    },
  );

  testWidgets(
    "When both are accepted then user can go to next screen.",
    (tester) async {
      bool isClicked = false;
      when(acceptPolicyViewModel.isCheckPrivacyPolicy).thenAnswer((realInvocation) => true);
      when(acceptPolicyViewModel.isCheckTermServices).thenAnswer((realInvocation) => true);
      when(purchaseItemViewModel.nft).thenAnswer((realInvocation) => MOCK_NFT_FREE_IMAGE);
      when(purchaseItemViewModel.isViewingFullNft).thenAnswer((realInvocation) => false);
      when(acceptPolicyViewModel.onTapGetStartedButton(MOCK_NFT_FREE_IMAGE)).thenAnswer((realInvocation) {
        isClicked = true;
      });
      await tester.testAppForWidgetTesting(
        AcceptPolicyScreen(
          nft: MOCK_NFT_FREE_IMAGE,
          viewModel: GetIt.I.get<AcceptPolicyViewModel>(),
        ),
      );
      await tester.pump();
      final kBottomSheetBtnKey = find.byKey(const Key(kAcceptBottomSheetBtnKey));
      await tester.tap(kBottomSheetBtnKey);
      await tester.pump();
      expect(isClicked, true);
    },
  );
}
