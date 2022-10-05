import 'package:flutter/material.dart';
import 'package:pylons_wallet/utils/constants.dart';

class PylonsAppTheme  {
  static const TextStyle HOME_TITLE = TextStyle(fontFamily: 'Inter', fontSize: 22);
  static const TextStyle HOME_LABEL = TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey);

  static const IconThemeData ICON_THEME_ENABLED = IconThemeData(color: Colors.indigo, size: 14);
  static const IconThemeData ICON_THEME_DISABLED = IconThemeData(color: Colors.white70, size: 14);

  static Color btnBackground = const Color(0x801212C4);

  static Color cardBackground = const Color(0xFFC4C4C4).withOpacity(0.2);

  static Color cardBackgroundSelected = const Color(0xFF1212C4).withOpacity(0.2);


  ThemeData buildAppTheme() {
    return ThemeData(
        scaffoldBackgroundColor: kMainBG,
        disabledColor: Colors.grey,
        dividerColor: Colors.grey,
        primarySwatch: Colors.blue,
        primaryColor: kBlue,
        fontFamily: kUniversalFontFamily,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            disabledForegroundColor: kBlue.withOpacity(0.38), disabledBackgroundColor: kBlue.withOpacity(0.12),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
            headline2: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'Inter', fontStyle: FontStyle.normal),
            subtitle1: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
            subtitle2: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
            bodyText1: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'Inter'),
            bodyText2: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Inter', color: Colors.black54),
            headline5: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, fontFamily: 'Inter', color: kBlue)));
  }
}
