import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';

import '../../helpers/size_extensions.dart';

void main() {
  testWidgets('should show more button and make sure user is able to tap with no text', (tester) async {
    final imageIconFinder = find.byIcon(Icons.keyboard_arrow_right_rounded);
    final more_text_finder = find.text("more");

    var isTapped = false;

    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(Material(
      child: MoreButton(
        onTap: () {
          isTapped = true;
        },
        showText: false,
      ),
    ));

    expect(imageIconFinder, findsOneWidget);

    // Expect user can press the button
    await tester.tap(imageIconFinder);

    expect(true, isTapped);
    expect(more_text_finder, findsNothing);
  });

  testWidgets('should show more button and make sure user is able to tap with show text', (tester) async {
    final imageIconFinder = find.byIcon(Icons.keyboard_arrow_right_rounded);
    final more_text_finder = find.text("more");

    var isTapped = false;

    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(Material(
      child: MoreButton(
        onTap: () {
          isTapped = true;
        },
      ),
    ));

    expect(imageIconFinder, findsOneWidget);

    // Expect user can press the button
    await tester.tap(imageIconFinder);

    expect(true, isTapped);
    expect(more_text_finder, findsOneWidget);
  });
}
