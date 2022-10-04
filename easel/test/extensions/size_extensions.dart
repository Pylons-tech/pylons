import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
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
        supportedLocales: const [Locale('en', 'US'), Locale('ru', 'RU'), Locale('es'), Locale('de')],
        path: 'i18n',
        fallbackLocale: const Locale('en'),
        useOnlyLangCode: true,
        child: ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: kEasel,
              theme: EaselAppTheme.theme(context),
              builder: (context, widget) {
                ScreenUtil.init(context);
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget!,
                );
              },
              home: child,
            );
          },
        ),
      );
    }), duration);
  }
}
