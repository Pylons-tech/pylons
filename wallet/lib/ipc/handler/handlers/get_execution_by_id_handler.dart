import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class GetExecutionByIdHandler implements BaseHandler {
  @override
  SdkIpcMessage sdkIpcMessage;

  GetExecutionByIdHandler(this.sdkIpcMessage);

  @override
  Future<SdkIpcResponse> handle() async {
    final jsonMap = jsonDecode(sdkIpcMessage.json) as Map;
    final executionId = jsonMap[HandlerFactory.EXECUTION_ID].toString();
    final walletsStore = GetIt.I.get<WalletsStore>();

    jsonMap.remove('nodeVersion');

    final response = await walletsStore.getExecutionBasedOnId(id: executionId);
    response.sender = sdkIpcMessage.sender;
    response.action = sdkIpcMessage.action;
    return SynchronousFuture(response);
  }
}
