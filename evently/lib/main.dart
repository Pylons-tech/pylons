import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently/screens/splash_screen.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/route_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool isTablet = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  isTablet = _getIsCurrentDeviceTablet();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
        Locale('es'),
        Locale('de'),
      ],
      path: 'i18n',
      fallbackLocale: const Locale('en', 'US'),
      saveLocale: false,
      child: const MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      builder: (BuildContext context, child) => MaterialApp(
        builder: (context, widget) {
          ScreenUtil.init(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
            child: widget!,
          );
        },
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Evently',
        navigatorKey: navigatorKey,
        theme: EventlyAppTheme.theme(context),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          RouteUtil.kRouteEventHub: (context) => const Placeholder(),
        },
      ),
    );
  }
}

bool _getIsCurrentDeviceTablet() {
  final MediaQueryData mediaQuery = MediaQueryData.fromView(PlatformDispatcher.instance.implicitView!);
  return mediaQuery.size.shortestSide >= tabletMinWidth;
}
