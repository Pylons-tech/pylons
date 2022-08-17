
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/ipc/handler/base_handler.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/pages/stripe_screen.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/third_party_services/stripe_handler.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class CreateStripeAccountHandler implements BaseHandler {
  @override
  SdkIpcMessage sdkIpcMessage;

  CreateStripeAccountHandler(this.sdkIpcMessage);

  @override
  Future<SdkIpcResponse> handle() async {
    final walletsStore = GetIt.I.get<WalletsStore>();

    if (walletsStore.getWallets().value.isEmpty) {
      final SdkIpcResponse sdkIpcResponse = SdkIpcResponse.failure(error: 'create_profile_before_using'.tr(), sender: sdkIpcMessage.sender, errorCode: HandlerFactory.ERR_PROFILE_DOES_NOT_EXIST);
      return sdkIpcResponse;
    }

    final loading = Loading()..showLoading();

    final account_response = await GetIt.I.get<StripeHandler>().handleStripeAccountLink();
    loading.dismiss();



    account_response.fold((fail) => {fail.message.show()}, (accountlink) {
      showDialog(
          useSafeArea: false,
          context: navigatorKey.currentState!.context,
          builder: (BuildContext context) {
            return StripeScreen(
                url: accountlink,
                onBack: () {
                  navigatorKey.currentState!.pop();
                });
          });
    });

    final SdkIpcResponse sdkIpcResponse = SdkIpcResponse.success(transaction: '', data: {}, sender: sdkIpcMessage.sender);

    return sdkIpcResponse;
  }
}
