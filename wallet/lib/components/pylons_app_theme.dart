import 'package:cosmos_ui_components/cosmos_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pylons_wallet/utils/constants.dart';

class PylonsAppTheme extends CosmosThemeData {
  static const TextStyle HOME_TITLE =
      TextStyle(fontFamily: 'Inter', fontSize: 22);
  static const TextStyle HOME_LABEL =
      TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey);

  static const IconThemeData ICON_THEME_ENABLED =
      IconThemeData(color: Colors.indigo, size: 14);
  static const IconThemeData ICON_THEME_DISABLED =
      IconThemeData(color: Colors.white70, size: 14);

  static Color btnBackground = const Color(0x801212C4);

  static Color cardBackground = const Color(0xFFC4C4C4).withOpacity(0.2);

  static Color cardBackgroundSelected =
      const Color(0xFF1212C4).withOpacity(0.2);

  /// Retrieves the correct [StaggeredTile] for provided tile index [index], for the Pylons app theme.
  ///
  /// The following diagram provides the expected size for each tile provided an index between 0 and 8,
  /// from left to right and top to bottom.
  ///
  /// ------------------------------------------------------------
  ///
  /// `1x1 2x2 2x2`
  ///
  /// `1x1 2x2 2x2`
  ///
  /// `1x1 1x1 1x1`
  static StaggeredTile getStaggeredTile(int index) {
    return StaggeredTile.count(
        (index == 1 || index == 6) ? 2 : 1, (index == 1 || index == 6) ? 2 : 1);
  }

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
            foregroundColor: kBlue,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
            headline2: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
                fontStyle: FontStyle.normal),
            subtitle1: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
            subtitle2: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
            bodyText1: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontFamily: 'Inter'),
            bodyText2: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Inter',
                color: Colors.black54),
            headline5: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                fontFamily: 'Inter',
                color: kBlue)));
  }
}
