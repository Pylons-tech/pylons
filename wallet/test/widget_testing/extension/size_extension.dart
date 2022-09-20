import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension SetScreenSize on WidgetTester {
  Future<void> setScreenSize({double width = 480, double height = 965, double pixelDensity = 1}) async {
    final size = Size(width, height);
    await binding.setSurfaceSize(size);
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = pixelDensity;
  }

  Future testAppForWidgetTesting(Widget child, {Duration duration = Duration.zero}) async {
    SharedPreferences.setMockInitialValues({});

    await EasyLocalization.ensureInitialized();

    return pumpWidget(Builder(builder: (context) {
      return EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ru'), Locale('id'), Locale('de'), Locale('ko'), Locale('ja'), Locale('es'), Locale('vi')],
        path: 'i18n',
        fallbackLocale: const Locale('en'),
        useOnlyLangCode: true,
        child: ScreenUtilInit(
          minTextAdapt: true,
          builder: () => MaterialApp(
            // key: UniqueKey(),
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: "Pylons Wallet",
            theme: PylonsAppTheme().buildAppTheme(),
            home: child,
          ),
        ),
      );
    }), duration);
  }
}
