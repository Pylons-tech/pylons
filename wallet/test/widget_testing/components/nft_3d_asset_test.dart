import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_3d_asset.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/provider/nft_3d_asset_provider.dart';
import 'package:pylons_wallet/utils/constants.dart';

import '../../mocks/mock_constants.dart';
import '../extension/size_extension.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Nft3DAssetProvider? provider;
  setUp(() {
    provider = Nft3DAssetProvider();
    provider!.toggleLoader();
  });

  testWidgets('test case for showing loader when 3D model is loading', (tester) async {
    await tester.setScreenSize();

    await tester.testAppForWidgetTesting(ChangeNotifierProvider(
        create: (context) => Nft3DAssetProvider(),
        builder: (context, widget) {
          return Consumer<Nft3DAssetProvider>(builder: (context, viewModel, __) {
            return Nft3DWidgetContent(
              backgroundColor: MOCK_COLOR,
              url: MOCK_URL,
              cameraControls: MOCK_CAMERA_CONTROLS,
              viewModel: viewModel,
              showLoader: MOCK_SHOW_LOADER_TRUE,
            );
          });
        }));
    final assetLoader = find.byKey(const Key(kImageAssetKey));
    await tester.pumpAndSettle();
    expect(assetLoader, findsOneWidget);
  });
  testWidgets('test case for not showing loader when 3D model is loaded', (tester) async {
    await tester.setScreenSize();

    await tester.testAppForWidgetTesting(ChangeNotifierProvider.value(
        value: provider,
        builder: (context, widget) {
          return Consumer<Nft3DAssetProvider>(builder: (context, viewModel, __) {
            return Nft3DWidgetContent(
              backgroundColor: MOCK_COLOR,
              url: MOCK_URL,
              cameraControls: MOCK_CAMERA_CONTROLS,
              viewModel: viewModel,
            );
          });
        }));
    final assetLoader = find.byKey(const Key(kImageAssetKey));
    await tester.pumpAndSettle();
    expect(assetLoader, findsNothing);
  });
}
