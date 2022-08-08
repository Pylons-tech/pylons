import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/components/buttons/next_button.dart';

import '../../helpers/size_extensions.dart';

void main() {
  testWidgets('should show next button and make sure user is able to tap',
      (tester) async {
    final iconFinder = find.byKey(const ValueKey('NextButton'));
    var isTapped = false;

    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(Material(
      child: NextButton(
        onTap: () {
          isTapped = true;
        },
      ),
    ));

    expect(iconFinder, findsOneWidget);

    // Expect user can press the button
    await tester.tap(iconFinder);

    expect(true, isTapped);
  });
}
