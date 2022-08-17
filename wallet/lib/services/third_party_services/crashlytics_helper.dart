import 'package:firebase_crashlytics/firebase_crashlytics.dart';

abstract class CrashlyticsHelper {
  /// This method will set the user identifier
  /// Input: [identifier] the identifier of the user
  void setUserIdentifier({required String identifier});

  /// This method will record the fatal error in crashlytics
  /// Input: [error] the error to record
  void recordFatalError({required String error});
}

class CrashlyticsHelperImpl implements CrashlyticsHelper {
  FirebaseCrashlytics crashlytics;

  CrashlyticsHelperImpl(this.crashlytics);

  @override
  void setUserIdentifier({required String identifier}) {
    crashlytics.setUserIdentifier(identifier);
  }

  @override
  void recordFatalError({required String error}) {
    crashlytics.recordError(error, StackTrace.empty, fatal: true);
  }
}
