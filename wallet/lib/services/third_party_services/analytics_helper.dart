import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsHelper {
  /// This method will set the user id in the firebase
  /// Input: [address] the address of the user
  Future<void> setUserId({required String address});
}

class AnalyticsHelperImpl implements AnalyticsHelper {
  FirebaseAnalytics firebaseAnalytics;
  AnalyticsHelperImpl({required this.firebaseAnalytics});

  @override
  Future<void> setUserId({required String address}) async {
    await FirebaseAnalytics.instance.setUserId(id: address);
  }
}
