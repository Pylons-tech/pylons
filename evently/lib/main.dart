import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/screens/buyer_status_screen.dart';
import 'package:evently/screens/create_event.dart';
import 'package:evently/screens/event_hub/event_hub_screen.dart';
import 'package:evently/screens/host_view_ticket_preview.dart';
import 'package:evently/screens/splash_screen.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/di/di.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/route_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

bool isTablet = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PylonsWallet.setup(mode: PylonsMode.prod, host: 'evently');

  await EasyLocalization.ensureInitialized();

  configureDependencies();

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<EventlyProvider>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(428, 932),
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
            RouteUtil.kRouteEventHub: (context) => const EventHubScreen(),
            RouteUtil.kCreateEvent: (context) => const CreateEvent(),
            RouteUtil.kHostTicketPreview: (context) => const HostTicketPreview(),
            RouteUtil.kBuyerResponse: (context) => const BuyerResponseScreen(),
          },
        ),
      ),
    );
  }
}

bool _getIsCurrentDeviceTablet() {
  final MediaQueryData mediaQuery = MediaQueryData.fromView(PlatformDispatcher.instance.implicitView!);
  return mediaQuery.size.shortestSide >= tabletMinWidth;
}
