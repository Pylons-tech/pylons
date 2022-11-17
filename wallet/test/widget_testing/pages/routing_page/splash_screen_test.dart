import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/routing_page/splash_screen.dart';
import 'package:pylons_wallet/providers/accounts_provider.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import '../../extension/size_extension.dart';

void main() {
  setUp(() {
    final TransactionSigningGateway gateway = TransactionSigningGateway();
    GetIt.I.registerLazySingleton(() => AccountProvider(transactionSigningGateway: gateway));
  });
  testWidgets("Add test for splash screen is rendering", (tester) async {
    expect(find.byType(SplashScreen), findsNothing);
    await tester.runAsync(() async {
      await tester.testAppForWidgetTesting(MultiProvider(providers: [
        Provider(
          create: (context) => GetIt.I<AccountProvider>(),
        ),
      ], child: const SplashScreen()));
      await tester.pumpAndSettle();
    });
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
