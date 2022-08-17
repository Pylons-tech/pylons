import 'dart:async';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_screen.dart';
import 'package:easel_flutter/screens/home_screen.dart';
import 'package:easel_flutter/screens/preview_nft/preview_nft_full_screen.dart';
import 'package:easel_flutter/screens/splash_screen.dart';
import 'package:easel_flutter/screens/tutorial_screen.dart';
import 'package:easel_flutter/screens/welcome_easel.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/dependency_injection/dependency_injection_container.dart' as di;
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/pdf_viewer_full_screen.dart';
import 'package:easel_flutter/widgets/video_widget_full_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import 'services/third_party_services/database.dart';

bool isTablet = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  di.init();
  final firebaseCrashlytics = GetIt.I.get<FirebaseCrashlytics>();

  runZonedGuarded(() async {
    await GetIt.I.isReady<AppDatabase>();
    await EasyLocalization.ensureInitialized();

    PylonsWallet.setup(mode: PylonsMode.prod, host: 'easel');

    isTablet = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide >= TABLET_MIN_WIDTH;

    FlutterError.onError = firebaseCrashlytics.recordFlutterError;

    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ru', 'RU')],
        path: 'i18n',
        fallbackLocale: const Locale('en', 'US'),
        saveLocale: false,
        child: const MyApp(),
      ),
    );
  }, (exception, stack) {
    firebaseCrashlytics.recordError(exception, stack);
  });
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GetIt.I.get<EaselProvider>()),
      ],
      child: ScreenUtilInit(
          minTextAdapt: true,
          builder: (BuildContext context, child) => MaterialApp(
                builder: (context, widget) {
                  ScreenUtil.init(context);
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  );
                },
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                title: 'Easel',
                navigatorKey: navigatorKey,
                theme: EaselAppTheme.theme(context),
                initialRoute: '/',
                routes: {
                  '/': (context) => const SplashScreen(),
                  RouteUtil.kRouteTutorial: (context) => const TutorialScreen(),
                  RouteUtil.kRouteCreatorHub: (context) => const CreatorHubScreen(),
                  RouteUtil.kRoutePreviewNFTFullScreen: (context) => const PreviewNFTFullScreen(),
                  RouteUtil.kRouteHome: (context) => const HomeScreen(),
                  RouteUtil.kVideoFullScreen: (context) => const VideoWidgetFullScreen(),
                  RouteUtil.kPdfFullScreen: (context) => const PdfViewerFullScreen(),
                  RouteUtil.kRouteWelcomeEasel: (context) => const WelcomeEasel(),
                },
              )),
    );
  }
}
