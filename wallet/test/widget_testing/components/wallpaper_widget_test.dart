import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/wallpaper_set_screen.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



import '../../mocks/mock_constants.dart';
import '../extension/size_extension.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test case for gestures', (tester) async {
    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(WallpaperScreen(
      nft: MOCK_NFT_FREE.url,
    ));
    await tester.pumpAndSettle();
    final gestureDetectorWallpaperScreen = find.byType(CustomPaintButton);
    await tester.ensureVisible(gestureDetectorWallpaperScreen);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(gestureDetectorWallpaperScreen, findsOneWidget);
  });

  testWidgets('test case for circle progress indicator', (tester) async {
    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(WallpaperScreen(
      nft: MOCK_NFT_FREE.url,
    ));
    await tester.pumpAndSettle();
    final gestureDetectorWallpaperScreen = find.byType(CustomPaintButton);
    await tester.tap(gestureDetectorWallpaperScreen);
    final circularProgressIndicator = find.byType(CircularProgressIndicator);
    await tester.ensureVisible(circularProgressIndicator);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
