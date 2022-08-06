import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/components/buttons/favorite_button.dart';

import '../../helpers/size_extensions.dart';

void main() {
  testWidgets('should show  favourite button and make sure user is able to tap', (tester) async {
    final iconFinder = find.byIcon(Icons.favorite_outline);
    var isTapped = false;

    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(Material(
      child: FavoriteButton(
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
