import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/components/buttons/add_friend_button.dart';
import 'package:pylons_wallet/components/buttons/favorite_button.dart';
import 'package:pylons_wallet/components/buttons/share_button.dart';

import '../../helpers/size_extensions.dart';

void main() {
  testWidgets('should show share button and make sure user is able to tap', (tester) async {
    final iconFinder = find.byIcon(Icons.share_outlined);
    var isTapped = false;

    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(Material(
      child: ShareButton(
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
