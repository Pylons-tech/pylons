import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class GetItemsByOwnerHandler implements BaseHandler {
  @override
  SdkIpcMessage sdkIpcMessage;

  GetItemsByOwnerHandler(this.sdkIpcMessage);

  @override
  Future<SdkIpcResponse> handle() async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final jsonMap = jsonDecode(sdkIpcMessage.json) as Map;
    final owner = jsonMap[HandlerFactory.OWNER_ADDRESS].toString();
    final response = await walletsStore.getItemListByOwner(owner: owner);
    response.sender = sdkIpcMessage.sender;
    response.action = sdkIpcMessage.action;
    return SynchronousFuture(response);
  }
}
