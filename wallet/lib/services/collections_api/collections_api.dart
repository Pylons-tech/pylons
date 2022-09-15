import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:get_it/get_it.dart';

import '../../stores/wallet_store.dart';

const MethodChannel _channel = MethodChannel('plugins.flutter.io/quick_actions_android');

/// An implementation of [QuickActionsPlatform] that for Android.
class CollectionsApi {
  /// Registers this class as the default instance of [QuickActionsPlatform].
  // static void registerWith() {
  //   QuickActionsPlatform.instance = QuickActionsAndroid();
  // }

  // /// The MethodChannel that is being used by this implementation of the plugin.
  // @visibleForTesting
  MethodChannel get channel => _channel;

  // Future<void> initialize() async {
  //   channel.setMethodCallHandler((MethodCall call) async {
  //     assert(call.method == 'launch');
  //     call.arguments as String;
  //   });
  //   final String? action =
  //   await channel.invokeMethod<String?>('getLaunchAction');
  //   if (action != null) {
  //     action;
  //   }
  // }

  // @override
  // Future<void> setShortcutItems(List<ShortcutItem> items) async {
  //   final List<Map<String, String?>> itemsList =
  //   items.map(_serializeItem).toList();
  //   await channel.invokeMethod<void>('setShortcutItems', itemsList);
  // }
  //
  // @override
  // Future<void> clearShortcutItems() =>
  //     channel.invokeMethod<void>('clearShortcutItems');

  Future<void> getCollection() async {

    final walletsStore = GetIt.I.get<WalletsStore>();
    final wallet = walletsStore.getWallets().value.last;
    final items = await walletsStore.getItemsByOwner(wallet.publicAddress);
    final message = <String>[];

    if (items.isNotEmpty) {
      await Future.wait(items.map((item) async {
        final nft = await NFT.fromItem(item);
        message.add(nft.url);
      }).toList());
    }

    await channel.invokeMethod<void>('getCollection', message);

  }

  // Map<String, String?> _serializeItem(ShortcutItem item) {
  //   return <String, String?>{
  //     'type': item.type,
  //     'localizedTitle': item.localizedTitle,
  //     'icon': item.icon,
  //   };
  // }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class _MyHomePageState extends State<MyHomePage> {
//   static const platform = MethodChannel('samples.flutter.dev/battery');
// // Get battery level.
//
//
//   String _batteryLevel = 'Unknown battery level.';
//
//   Future<void> _getBatteryLevel() async {
//     String batteryLevel;
//     try {
//       final int result = await platform.invokeMethod('getBatteryLevel');
//       batteryLevel = 'Battery level at $result % .';
//     } on PlatformException catch (e) {
//       batteryLevel = "Failed to get battery level: '${e.message}'.";
//     }
//
//     setState(() {
//       _batteryLevel = batteryLevel;
//     });
//   }