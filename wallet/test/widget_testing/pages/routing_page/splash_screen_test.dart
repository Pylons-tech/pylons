import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/pages/routing_page/splash_screen.dart';
import '../../extension/size_extension.dart';

void main() {
  testWidgets("Add test for splash screen is rendering", (tester) async {
    expect(find.byType(SplashScreen), findsNothing);
    await tester.runAsync(() async {
      await tester.testAppForWidgetTesting(const SplashScreen());
      await tester.pumpAndSettle();
    });
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
