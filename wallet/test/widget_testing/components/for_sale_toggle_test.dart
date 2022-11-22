import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/toggle_button.dart';
import '../extension/size_extension.dart';
import '../../mocks/owner_view_view_model.mocks.dart';




void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late OwnerViewViewModel ownerViewViewModel;
  ownerViewViewModel = MockOwnerViewViewModel();
  GetIt.I.registerLazySingleton<OwnerViewViewModel>(() => ownerViewViewModel);

  testWidgets('test case for toggle button visibility', (tester) async {
    when(ownerViewViewModel.toggled).thenAnswer((realInvocation) => Toggle.disabled);
    when(ownerViewViewModel.setToggle(toggle: Toggle.mid)).thenAnswer((realInvocation) => Toggle.mid);
    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(Material(
        child: ToggleButton(assetProvider: ownerViewViewModel)));
    await tester.pumpAndSettle();
    final toggleButtonWidget = find.byType(ToggleButton);
    await tester.ensureVisible(toggleButtonWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(toggleButtonWidget, findsOneWidget);
  });
}
