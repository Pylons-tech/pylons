import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/components/maintenance_mode_widgets.dart';
import '../extension/size_extension.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test case for maintenance mode banner widget', (tester) async {
    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(const Material(
        child: MaintenanceModeBannerWidget()));
    await tester.pumpAndSettle();
    final maintenanceModeBannerWidget = find.byType(MaintenanceModeBannerWidget);
    await tester.ensureVisible(maintenanceModeBannerWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(maintenanceModeBannerWidget, findsOneWidget);
  });

  testWidgets('test case for maintenance mode message widget', (tester) async {
    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(const Material(
        child: MaintenanceModeMessageWidget()));
    await tester.pumpAndSettle();
    final maintenanceModeMessageWidget = find.byType(MaintenanceModeMessageWidget);
    await tester.ensureVisible(maintenanceModeMessageWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(maintenanceModeMessageWidget, findsOneWidget);
  });
}
