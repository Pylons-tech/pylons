import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart' as di;
import 'package:pylons_wallet/utils/types.dart';

import 'gen/assets.gen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await EasyLocalization.ensureInitialized();
  // Read the values from .env file
  await dotenv.load(fileName: Assets.env.localEnv);
  await di.init(
    onLogEvent: (AnalyticsEventEnum event) {},
    onLogError: (exception, {bool fatal = false, StackTrace? stack}) {
      FirebaseCrashlytics.instance.recordError(exception, stack, fatal: fatal);
    },
  );

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ru')],
        path: 'i18n',
        fallbackLocale: const Locale('en'),
        saveLocale: false,
        useOnlyLangCode: true,
        child: PylonsApp()),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
