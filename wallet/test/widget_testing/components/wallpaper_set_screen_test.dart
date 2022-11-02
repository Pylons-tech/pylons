import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_image_asset.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/wallpaper_set_screen.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';

import '../../mocks/mock_constants.dart';
import '../extension/size_extension.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockBuildContext _mockContext;

  testWidgets('test case for nft visibility', (tester) async {
    _mockContext = MockBuildContext();
    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(WallpaperScreen(
      nft: MOCK_NFT_FREE_IMAGE.url, context: _mockContext).test(),
    );
    await tester.pumpAndSettle();
    final gestureDetectorWallpaperScreen = find.byType(NftImageWidget);
    await tester.ensureVisible(gestureDetectorWallpaperScreen);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(gestureDetectorWallpaperScreen, findsOneWidget);
  });

  testWidgets('test case for set wallpaper button press', (tester) async {
    tester.runAsync(() async {
      _mockContext = MockBuildContext();
      await tester.testAppForWidgetTesting(WallpaperScreen(
          nft: MOCK_NFT_FREE_IMAGE.url, context: _mockContext).test(),);
      await tester.pumpAndSettle();
      final gestureDetectorWallpaperScreen = find.byType(CustomPaintButton);
      await tester.ensureVisible(gestureDetectorWallpaperScreen);
      await tester.tap(gestureDetectorWallpaperScreen);

      await tester.pumpAndSettle(const Duration(seconds: 20));
      expect(gestureDetectorWallpaperScreen, findsOneWidget);


    });
  });

}
