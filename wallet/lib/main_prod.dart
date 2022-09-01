import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart' as di;
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';

bool isTablet = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );
  await dotenv.load(fileName: "env/.prod_env");

  await di.init();

  Stripe.publishableKey = sl<BaseEnv>().baseStripPubKey;
  Stripe.merchantIdentifier = "merchant.tech.pylons.wallet";

  runZonedGuarded<Future<void>>(() async {
    isTablet = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide >= TABLET_MIN_LENGTH;
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ru'), Locale('id'), Locale('de'), Locale('ko'), Locale('ja'), Locale('es'), Locale('vi')],
        path: 'i18n',
        fallbackLocale: const Locale('en'),
        useOnlyLangCode: true,
        child: PylonsApp(),
      ),
    );
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
