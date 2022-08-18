import 'package:firebase_crashlytics/firebase_crashlytics.dart';

abstract class CrashlyticsHelper {
  /// This method will set the user identifier
  /// Input: [identifier] the identifier of the user
  void setUserIdentifier({required String identifier});

  /// This method will record the fatal error in crashlytics
  /// Input: [error] the error to record
  void recordFatalError({required String error});
}

class CrashlyticsHelperImp extends CrashlyticsHelper {
  final FirebaseCrashlytics crashlytics;

  CrashlyticsHelperImp({required this.crashlytics});

  @override
  void recordFatalError({required String error}) {
    crashlytics.recordError(error, StackTrace.empty, fatal: true);
  }

  @override
  void setUserIdentifier({required String identifier}) {
    crashlytics.setUserIdentifier(identifier);
  }
}
