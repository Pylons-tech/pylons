import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/components/buttons/pylons_blue_button_with_loader.dart';

import '../../helpers/size_extensions.dart';

void main() {
  testWidgets(
      'should show pylons blue button loading button and make sure user is able to tap',
      (tester) async {
    final imageIconFinder =
        find.byKey(const ValueKey("Pylons-Blue-Button-Loading"));
    final isTapped = ValueNotifier(false);

    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(Material(
      child: PylonsBlueButtonLoading(
        key: const Key("Pylons-Blue-Button-Loading"),
        loader: isTapped,
        onTap: () {
          isTapped.value = true;
        },
      ),
    ));

    expect(imageIconFinder, findsOneWidget);

    // Expect user can press the button
    await tester.tap(imageIconFinder);

    expect(true, isTapped.value);
  });
}
