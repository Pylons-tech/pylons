import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsHelper {
  /// This method will set the user identifier
  /// Input: [identifier] the identifier of the user
  void setUserIdentifier({required String identifier});

}

class AnalyticsHelperImp extends AnalyticsHelper {
  final FirebaseAnalytics analytics;

  AnalyticsHelperImp({required this.analytics});



  @override
  void setUserIdentifier({required String identifier}) {
    analytics.setUserId(id: identifier);
  }
}
