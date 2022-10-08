import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_3d_asset.dart';
import 'package:pylons_wallet/utils/constants.dart';

import '../../mocks/mock_constants.dart';
import '../extension/size_extension.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test case for showing loader when 3D model is loading', (tester) async {
    await tester.setScreenSize();

    await tester.testAppForWidgetTesting(Nft3dWidget(
      backgroundColor: MOCK_COLOR,
      url: MOCK_URL,
      cameraControls: MOCK_CAMERA_CONTROLS,
      showLoader: MOCK_SHOW_LOADER_TRUE,
    ));
    final assetLoader = find.byKey(const Key(kImageAssetKey));
    await tester.pumpAndSettle();
    expect(assetLoader, findsOneWidget);
  });
  testWidgets('test case for not showing loader when 3D model is loaded', (tester) async {
    await tester.setScreenSize();

    await tester.testAppForWidgetTesting(Nft3dWidget(
      backgroundColor: MOCK_COLOR,
      url: MOCK_URL,
      cameraControls: MOCK_CAMERA_CONTROLS,
      showLoader: MOCK_SHOW_LOADER_FALSE,
    ));
    final assetLoader = find.byKey(const Key(kImageAssetKey));
    await tester.pumpAndSettle();
    expect(assetLoader, findsNothing);
  });
}
