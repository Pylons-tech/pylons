import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/size_extensions.dart';

// TODO: can someone w/ more experience in writing widget tests look over these? they work, but they're incredibly ugly
void main() {
  testWidgets('Test avatar loading/rejection', (tester) async {
    await tester.setScreenSize();
    SharedPreferences.setMockInitialValues({});
    await tester.testAppForWidgetTesting(const Material(
        child: UserAvatarWidget(
      radius: 10.0,
    )));
    final widget = find.byType(UserAvatarWidget);
    expect(widget, findsOneWidget);
    final avatar = tester.widget(widget) as UserAvatarWidget;
    await tester.pumpWidget(MaterialApp(
        color: Colors.white,
        builder: (BuildContext context, w) {
          log('Expect default avatar, since no extant values in sharedPreferences');
          expect(
              avatar.getImage(
                  UserAvatarWidget.defaultImage, UserAvatarWidget.uriKey),
              UserAvatarWidget.defaultImage);
          log('Set avatar to legal value; expect that image now');
          UserImageWidget.setToFile(
              UserAvatarWidget.filesizeLimit,
              UserAvatarWidget.uriKey,
              File('assets/images/testing/low_res_low_filesize.png'),
              context);
          expect(
              avatar.getImage(
                  UserAvatarWidget.defaultImage, UserAvatarWidget.uriKey),
              isNot(UserAvatarWidget.defaultImage));
          log('Set avatar to illegal (high-filesize) value; expect unchanged');
          final avatarToExpect = avatar.getImage(
              UserAvatarWidget.defaultImage, UserAvatarWidget.uriKey);
          UserImageWidget.setToFile(
              UserAvatarWidget.filesizeLimit,
              UserAvatarWidget.uriKey,
              File('assets/images/testing/low_res_high_filesize.png'),
              context);
          expect(
              avatar.getImage(
                  UserAvatarWidget.defaultImage, UserAvatarWidget.uriKey),
              avatarToExpect);
          return avatar;
        }));
    await tester.pumpAndSettle();
  });

}
