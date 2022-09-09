import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class ExecuteRecipeHandler implements BaseHandler {
  @override
  SdkIpcMessage sdkIpcMessage;

  ExecuteRecipeHandler(this.sdkIpcMessage);

  @override
  Future<SdkIpcResponse> handle() async {
    final jsonMap = jsonDecode(sdkIpcMessage.json) as Map;

    jsonMap.remove('nodeVersion');

    final walletsStore = GetIt.I.get<WalletsStore>();

    final responseEither = await walletsStore.executeRecipe(jsonMap);
    final response = responseEither.toOption().toNullable();
    response!.sender = sdkIpcMessage.sender;
    response.action = sdkIpcMessage.action;
    return SynchronousFuture(response);
  }
}
