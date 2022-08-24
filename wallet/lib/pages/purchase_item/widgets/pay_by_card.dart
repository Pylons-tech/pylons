import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/model/stripe_create_payment_intent_request.dart';
import 'package:pylons_wallet/model/stripe_create_payment_intent_response.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_request.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_response.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/constants.dart' as constants;
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/formatter.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class PayByCardWidget extends StatelessWidget {
  const PayByCardWidget({Key? key, required this.recipe}) : super(key: key);

  final NFT recipe;

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Stack(
      children: [
        Positioned(
          right: 0,
          child: SizedBox(
            width: screenSize.width(),
            child: Padding(
              padding: const EdgeInsets.only(left: 50),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    height: screenSize.height(percent: 0.35),
                    // width: screenSize.width(),
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: screenSize.height(percent: 0.35),
          width: screenSize.width(),
          margin: const EdgeInsets.only(left: 50),
          decoration: BoxDecoration(
            color: kWhite.withOpacity(0.4),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
          ),
          child: DecoratedBox(
            // padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kBlue.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  recipe.name,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const UserAvatarWidget(radius: 10),
                    const HorizontalSpace(30),
                    Text(
                      recipe.denom.UdenomToDenom().toUpperCase(),
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                    ),
                    const HorizontalSpace(30),
                    Text(
                      recipe.price.UvalToVal(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: kWhite.withOpacity(0.35),
                    side: BorderSide(color: kWhite.withOpacity(0.4)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  ),
                  icon: Image.asset(
                    'assets/images/icons/card.png',
                    width: 30,
                  ),
                  label: Text(
                    "pay".tr(),
                    style: Theme.of(context).textTheme.button!.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    executeRecipe(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> stripePaymentForTrade(BuildContext context, NFT nft) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final repository = GetIt.I.get<Repository>();
    final baseEnv = GetIt.I.get<BaseEnv>();
    showLoading(context);
    final response = await repository.CreatePaymentIntent(
        StripeCreatePaymentIntentRequest(
            productID: "trade/${nft.tradeID}",
            coinInputIndex: 0,
            address: walletsStore.getWallets().value.last.publicAddress));
    final pi_info =
        response.getOrElse(() => StripeCreatePaymentIntentResponse());
    if (pi_info.clientsecret != "") {
      try {
        final pi =
            await Stripe.instance.retrievePaymentIntent(pi_info.clientsecret);

        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                applePay: true,
                googlePay: true,
                style: ThemeMode.system,
                testEnv: baseEnv.baseStripeTestEnv,
                merchantCountryCode: constants.kStripeMerchantCountry,
                merchantDisplayName: constants.kStripeMerchantDisplayName,
                paymentIntentClientSecret: pi_info.clientsecret));
        Navigator.pop(navigatorKey.currentState!.overlay!.context);

        await Stripe.instance.presentPaymentSheet();

        final receipt_response = await repository.GeneratePaymentReceipt(
            StripeGeneratePaymentReceiptRequest(
                paymentIntentID: pi.id, clientSecret: pi.clientSecret));

        final receipt = receipt_response
            .getOrElse(() => StripeGeneratePaymentReceiptResponse());

        showLoading(navigatorKey.currentState!.overlay!.context);
        const json = '''
        {
          "ID": 0,
          "coinInputsIndex": 0,
          "paymentInfos": []
        }
        ''';
        final jsonMap = jsonDecode(json) as Map;
        jsonMap["ID"] = recipe.tradeID;
        final paymentInfos = jsonMap["paymentInfos"] as List<dynamic>;
        paymentInfos.add(receipt.toJson());

        final tradeResponse = await walletsStore.fulfillTrade(jsonMap);

        Navigator.pop(navigatorKey.currentState!.overlay!.context);

        tradeResponse.success
            ? "purchase_nft_success".tr()
            : tradeResponse.error.show();
      } catch (error) {
        Navigator.pop(navigatorKey.currentState!.overlay!.context);
      }
    }
  }

  Future<void> stripePaymentForRecipe(BuildContext context, NFT nft) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final repository = GetIt.I.get<Repository>();
    final baseEnv = GetIt.I.get<BaseEnv>();
    showLoading(context);

    final response = await repository.CreatePaymentIntent(
        StripeCreatePaymentIntentRequest(
            productID: "recipe/${nft.cookbookID}/${nft.recipeID}",
            coinInputIndex: 0,
            address: walletsStore.getWallets().value.last.publicAddress));
    final pi_info =
        response.getOrElse(() => StripeCreatePaymentIntentResponse());

    if (pi_info.clientsecret != "") {
      try {
        final pi =
            await Stripe.instance.retrievePaymentIntent(pi_info.clientsecret);

        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                applePay: true,
                googlePay: true,
                style: ThemeMode.system,
                testEnv: baseEnv.baseStripeTestEnv,
                merchantCountryCode: constants.kStripeMerchantCountry,
                merchantDisplayName: constants.kStripeMerchantDisplayName,
                paymentIntentClientSecret: pi_info.clientsecret));
        Navigator.pop(navigatorKey.currentState!.overlay!.context);
        await Stripe.instance.presentPaymentSheet();

        final receipt_response = await repository.GeneratePaymentReceipt(
            StripeGeneratePaymentReceiptRequest(
                paymentIntentID: pi.id, clientSecret: pi.clientSecret));

        final receipt = receipt_response
            .getOrElse(() => StripeGeneratePaymentReceiptResponse());

        const jsonExecuteRecipe = '''
        {
          "creator": "",
          "cookbookID": "",
          "recipeID": "",
          "coinInputsIndex": 0,
          "paymentInfos": []
        }
        ''';

        final jsonMap = jsonDecode(jsonExecuteRecipe) as Map;
        jsonMap["cookbookID"] = recipe.cookbookID;
        jsonMap["recipeID"] = recipe.recipeID;

        final paymentInfos = jsonMap["paymentInfos"] as List<dynamic>;
        paymentInfos.add(receipt.toJson());

        showLoading(navigatorKey.currentState!.overlay!.context);

        final execution = await walletsStore.executeRecipe(jsonMap);

        Navigator.pop(navigatorKey.currentState!.overlay!.context);

        (execution.success ? "purchase_nft_success".tr() : execution.error)
            .show();

        Navigator.of(navigatorKey.currentState!.overlay!.context)
            .pushNamed(RouteUtil.ROUTE_HOME);
      } catch (error) {
        Navigator.pop(navigatorKey.currentState!.overlay!.context);
      }
    }
  }

  Future<void> executeRecipe(BuildContext context) async {
    switch (recipe.type) {
      case NftType.TYPE_RECIPE:
        if (recipe.denom.UdenomToDenom().toLowerCase() ==
            constants.kUSDCoinName) {
          stripePaymentForRecipe(context, recipe);
        } else {
          context.read<PurchaseItemViewModel>().paymentForRecipe();
        }
        break;
      case NftType.TYPE_ITEM:
        break;
      case NftType.TYPE_TRADE:
        if (recipe.denom.UdenomToDenom().toLowerCase() ==
            constants.kUSDCoinName) {
          stripePaymentForTrade(context, recipe);
        } else {
          context.read<PurchaseItemViewModel>().paymentForTrade();
        }
        break;
    }
  }

  void showLoading(BuildContext context) {
    Loading().showLoading();
  }
}
