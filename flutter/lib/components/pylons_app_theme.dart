import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';

class PylonsAppTheme extends CosmosAppTheme {


  static const TextStyle HOME_TITLE = TextStyle(fontFamily: 'Inter', fontSize: 22);
  static const TextStyle HOME_LABEL = TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey);

  static const IconThemeData ICON_THEME_ENABLED = IconThemeData(color: Colors.indigo,size: 14);
  static const IconThemeData ICON_THEME_DISABLED = IconThemeData(color: Colors.white70,size: 14);


  static ThemeData buildAppTheme() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      disabledColor: Colors.grey,
      dividerColor: Colors.grey,
      primarySwatch: Colors.blue,
      fontFamily: 'Inter',
      elevatedButtonTheme : ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
