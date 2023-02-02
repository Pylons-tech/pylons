import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/providers/collections_tab_provider.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart' as pylons;

import '../../../model/nft.dart';
import '../../../providers/recipes_provider.dart';

class CreateRecipeHandler implements BaseHandler {
  CreateRecipeHandler(this.sdkIpcMessage);

  @override
  Future<SdkIpcResponse> handle() async {
    final jsonMap = jsonDecode(sdkIpcMessage.json) as Map;

    jsonMap.remove('nodeVersion');
    final loading = Loading()..showLoading();

    final walletsStore = GetIt.I.get<WalletsStore>();

    final response = await walletsStore.createRecipe(jsonMap);
    loading.dismiss();
    response.sender = sdkIpcMessage.sender;
    response.action = sdkIpcMessage.action;

    if (response.success) {
      if (shouldShowNFTPreview()) {
        final msgObj = pylons.MsgCreateRecipe.create()..mergeFromProto3Json(jsonMap);

        final nft = await NFT.fromRecipeId(msgObj.cookbookId, msgObj.id);

        if (nft != null) {
          await navigatorKey.currentState!.pushNamed(RouteUtil.ROUTE_OWNER_VIEW, arguments: nft);
        }

        GetIt.I.get<HomeProvider>().changeTabs(0);
        GetIt.I.get<CollectionsTabProvider>().collectionsType = CollectionsType.creations;
        GetIt.I.get<RecipesProvider>().getCookBooks();
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
