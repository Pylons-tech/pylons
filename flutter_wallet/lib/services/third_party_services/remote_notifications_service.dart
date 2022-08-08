import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pylons_wallet/pages/home/message_screen/nft_sold_dialog.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';

/// This class will act as a view model for the notifications
abstract class RemoteNotificationsService {
  /// This method gives token for remote notifications
  /// Output : [String] token used to identify device for remote messaging
  Future<String> getToken();

  /// This method gives the notification permission only in IOS
  Future getNotificationsPermission();

  /// This method listens to the firebase notification when the app is in foreground
  void listenToForegroundNotification();
}

class RemoteNotificationsServiceImp implements RemoteNotificationsService {
  static const String CHANNEL_ID = 'pylons_channel';
  static const String CHANNEL_NAME = 'Pylons related notifications';
  static const String CHANNEL_DESCRIPTION =
      'This channel is used for important notifications.';

  final FirebaseMessaging firebaseMessaging;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  RemoteNotificationsServiceImp({
    required this.firebaseMessaging,
    required this.flutterLocalNotificationsPlugin,
  });

  @override
  Future<String> getToken() async {
    final token = await firebaseMessaging.getToken();
    if (token == null || token.isEmpty) {
      throw FcmTokenRetrievalError("something_went_wrong".tr());
    }
    return token;
  }

  @override
  Future getNotificationsPermission() async {
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const initializationSettingsMacOS = MacOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    const channel = AndroidNotificationChannel(
      CHANNEL_ID,
      CHANNEL_NAME,
      description: CHANNEL_DESCRIPTION, // description
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    return false;
  }

  @override
  void listenToForegroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        print(message);
        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      }

      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(CHANNEL_ID, CHANNEL_NAME,
                  channelDescription: CHANNEL_DESCRIPTION,
                  icon: android.smallIcon,
                  importance: Importance.max),
            ));
      }
      onReceiveNotificationHandler(message.data, notification!);
    });
  }

  void onReceiveNotificationHandler(
      Map<String, dynamic> data, RemoteNotification notification) {
    if (kNftSold == data[kType]) {
      final NftSoldDialog nftSoldDialog = NftSoldDialog(
        notification: notification,
        context: navigatorKey.currentState!.overlay!.context,
      );
      nftSoldDialog.show();
    }
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  void selectNotification(String? payload) {}
}
