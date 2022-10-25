import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsHelper {
  /// This method will set the user identifier
  /// Input: [identifier] the identifier of the user
  void setUserIdentifier({required String identifier});

  Future<bool> logUserJourney({required String screenName});
}

class AnalyticsHelperImp extends AnalyticsHelper {
  final FirebaseAnalytics analytics;

  AnalyticsHelperImp({required this.analytics});

  @override
  void setUserIdentifier({required String identifier}) {
    analytics.setUserId(id: identifier);
  }

  @override
  Future<bool> logUserJourney({required String screenName}) async {
    await FirebaseAnalytics.instance.logEvent(name: screenName);
    return true;
  }
}
