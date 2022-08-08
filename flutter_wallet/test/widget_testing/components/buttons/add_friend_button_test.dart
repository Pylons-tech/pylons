import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/components/buttons/add_friend_button.dart';

import '../../helpers/size_extensions.dart';

void main() {
  testWidgets('should show add friend button and make sure user is able to tap',
      (tester) async {
    final imageIconFinder = find.byKey(const ValueKey("Add-Friend-Button"));
    var isTapped = false;

    await tester.setScreenSize();
    await tester.testAppForWidgetTesting(Material(
      child: AddFriendButton(
        onTap: () {
          isTapped = true;
        },
      ),
    ));

    expect(imageIconFinder, findsOneWidget);

    // Expect user can press the button
    await tester.tap(imageIconFinder);

    expect(true, isTapped);
  });
}
