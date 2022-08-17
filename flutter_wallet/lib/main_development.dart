import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart'
as di;
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //for HTTPS
  //HttpOverrides.global = MyHttpOverrides();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  // Read the values from .env file
  await dotenv.load(fileName: "env/.dev_env");
  await di.init();



  isTablet = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide >= TABLET_MIN_LENGTH;



  Stripe.publishableKey = sl<BaseEnv>().baseStripPubKey;
  Stripe.merchantIdentifier = "merchant.tech.pylons.wallet";
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
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
