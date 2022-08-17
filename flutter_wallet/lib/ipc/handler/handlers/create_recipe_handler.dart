import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_view_model.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/route_util.dart';

class CreateRecipeHandler implements BaseHandler {
  CreateRecipeHandler(this.sdkIpcMessage);

  @override
  Future<SdkIpcResponse> handle() async {
    final jsonMap = jsonDecode(sdkIpcMessage.json) as Map;

    jsonMap.remove('nodeVersion');
    final loading = Loading()..showLoading(message: "${'creating_recipe'.tr()}...");

    final walletsStore = GetIt.I.get<WalletsStore>();

    final response = await walletsStore.createRecipe(jsonMap);
    loading.dismiss();
    response.sender = sdkIpcMessage.sender;
    response.action = sdkIpcMessage.action;

    if (response.success) {
      if (shouldShowNFTPreview()) {

        GetIt.I.get<HomeProvider>().changeTabs(0);
        navigatorKey.currentState!.pushNamedAndRemoveUntil(RouteUtil.ROUTE_HOME , (_) => false);
        GetIt.I.get<CollectionViewModel>().collectionsType = CollectionsType.creations;
        GetIt.I.get<CollectionViewModel>().loadPurchasesAndCreationsData();
      } else {
        "Recipe ${jsonMap['name']} Created".show();
      }
    } else {
      "Recipe ${jsonMap['name']} error: ${response.error}".show();
    }
    return SynchronousFuture(response);
  }

  bool shouldShowNFTPreview() => !sdkIpcMessage.requestResponse;

  @override
  SdkIpcMessage sdkIpcMessage;
}
