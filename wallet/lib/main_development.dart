
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart' as di;
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/types.dart';

import 'gen/assets.gen.dart';
import 'utils/extension.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //for HTTPS
  //HttpOverrides.global = MyHttpOverrides();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

   void logMessage(String message) {
    FirebaseCrashlytics.instance.log(message);
  }

  // Read the values from .env file
  await dotenv.load(fileName: Assets.env.devEnv);
  await di.init(
    onLogEvent: (AnalyticsEventEnum event) {},
    onLogError: (exception, {bool fatal = false, StackTrace? stack}) {
      FirebaseCrashlytics.instance.recordError(exception, stack, fatal: fatal);
    }, onLogMessage: logMessage,
  );

  isTablet = getIsCurrentDeviceTablet();

  Stripe.publishableKey = sl<BaseEnv>().baseStripPubKey;
  Stripe.merchantIdentifier = "merchant.tech.pylons.wallet";
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'i18n',
      fallbackLocale: const Locale('en'),
      saveLocale: false,
      useOnlyLangCode: true,
      child: PylonsApp(onLogMessage: logMessage),
    ),
  );
}