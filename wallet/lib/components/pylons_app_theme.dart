import 'package:flutter/material.dart';
import 'package:pylons_wallet/gen/fonts.gen.dart';
import 'package:pylons_wallet/utils/constants.dart';

class PylonsAppTheme {
  static const TextStyle HOME_TITLE = TextStyle(fontFamily: FontFamily.inter, fontSize: 22);
  static const TextStyle HOME_LABEL = TextStyle(fontFamily: FontFamily.inter, fontSize: 14, color: Colors.grey);

  static const IconThemeData ICON_THEME_ENABLED = IconThemeData(color: Colors.indigo, size: 14);
  static const IconThemeData ICON_THEME_DISABLED = IconThemeData(color: Colors.white70, size: 14);

  static Color btnBackground = const Color(0x801212C4);

  static Color cardBackground = const Color(0xFFC4C4C4).withOpacity(0.2);

  static Color cardBackgroundSelected = const Color(0xFF1212C4).withOpacity(0.2);

  ThemeData buildAppTheme() {
    return ThemeData(
        scaffoldBackgroundColor: AppColors.kMainBG,
        disabledColor: Colors.grey,
        dividerColor: Colors.grey,
        primarySwatch: Colors.blue,
        primaryColor: AppColors.kBlue,
        fontFamily: kUniversalFontFamily,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            disabledForegroundColor: AppColors.kBlue.withOpacity(0.38),
            disabledBackgroundColor: AppColors.kBlue.withOpacity(0.12),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: FontFamily.inter),
          displayMedium: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: FontFamily.inter, fontStyle: FontStyle.normal),
          titleMedium: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, fontFamily: FontFamily.inter),
          titleSmall: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: FontFamily.inter),
          bodyLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: FontFamily.inter),
          bodyMedium: const TextStyle(fontWeight: FontWeight.normal, fontFamily: FontFamily.inter, color: Colors.black54),
          headlineSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, fontFamily: FontFamily.inter, color: AppColors.kBlue),
        ));
  }
}
