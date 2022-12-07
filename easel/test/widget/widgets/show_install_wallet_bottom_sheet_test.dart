import 'package:easel_flutter/screens/welcome_screen/widgets/show_install_wallet_bottom_sheet.dart';
import 'package:easel_flutter/screens/welcome_screen/widgets/viewModel/show_install_wallet_bottom_sheet_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import '../../extensions/size_extension.dart';
import '../../mock/show_install_wallet_view_model.mocks.dart';

void main() {
  final viewModel = MockShowInstallBottomSheetViewModel();
  setUpAll(() {
    GetIt.I.registerLazySingleton<ShowInstallBottomSheetViewModel>(() => viewModel);
  });
  testWidgets('check user can click on download button', (tester) async {
    when(viewModel.goToInstall()).thenAnswer((realInvocation) => Future.value(true));
    await tester.testAppForWidgetTesting(
      const Material(
        child: ShowInstallWalletBottomSheetContent(),
      ),
    );
    final button = find.byType(InkWell);
    await tester.tap(button);
    verify(viewModel.goToInstall()).called(1);
  });
}
