import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

/// This handler handles the create cookbook transaction request from third-party apps
class CreateCookbookHandler implements BaseHandler {
  CreateCookbookHandler(this.sdkIpcMessage);

  @override
  Future<SdkIpcResponse> handle() async {
    final jsonMap = jsonDecode(sdkIpcMessage.json) as Map;

    jsonMap.remove('nodeVersion');
    final loading = Loading()
      ..showLoading(message: "${'creating_cookbook'.tr()}...");

    final walletsStore = GetIt.I.get<WalletsStore>();

    final response = await walletsStore.createCookbook(jsonMap);
    loading.dismiss();
    response.sender = sdkIpcMessage.sender;
    response.action = sdkIpcMessage.action;
    if (response.error == "") {
      "Cookbook ${jsonMap['name']} created".show();
    } else {
      "Cookbook ${jsonMap['name']} error: ${response.error}".show();
    }

    return SynchronousFuture(response);
  }

  @override
  SdkIpcMessage sdkIpcMessage;
}
