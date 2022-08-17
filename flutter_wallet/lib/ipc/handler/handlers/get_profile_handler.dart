import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/model/balance.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/item.pb.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class GetProfileHandler implements BaseHandler {
  @override
  SdkIpcMessage sdkIpcMessage;

  GetProfileHandler(this.sdkIpcMessage);

  @override
  Future<SdkIpcResponse> handle() async {
    final walletsStore = GetIt.I.get<WalletsStore>();

    final loading = Loading()..showLoading(message: "${'getting_profile'.tr()}...");

    final response = await walletsStore.getProfile();
    loading.dismiss();

    response.sender = sdkIpcMessage.sender;
    response.action = sdkIpcMessage.action;
    return SynchronousFuture(response);
  }
}

class Profile {
  final String address;
  final String username;
  final bool stripeExists;
  final List<Balance> coins;
  final List<Item> items;
  final List<String> supportedCoins;

  Profile({required this.address, required this.username, required this.coins, required this.stripeExists, required this.items, required this.supportedCoins});

  Map<String, dynamic> toJson() => {
        "address": address,
        "username": username,
        "stripeExists": stripeExists,
        "coins": coins.map((Balance balance) => balance.toJson()).toList(),
        "items": items.map((Item item) => item.toProto3Json()).toList(),
        "supportedCoins" : supportedCoins
      };

  @override
  String toString() {
    return 'Profile{address: $address, username: $username, stripeExists: $stripeExists, coins: $coins, items: $items, supportedCoins: $supportedCoins}';
  }
}
