import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/model/stripe_create_payment_intent_request.dart';
import 'package:pylons_wallet/model/stripe_create_payment_intent_response.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_request.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_response.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/insufficient_balance_dialog.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/pay_with_swipe.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/svg_util.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

TextStyle _titleTextStyle = TextStyle(color: Colors.white, fontSize: 16.sp);
TextStyle _subtitleTextStyle = TextStyle(color: Colors.white, fontSize: 12.sp);
TextStyle _rowTitleTextStyle = TextStyle(
    color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.sp);
TextStyle _rowSubtitleTextStyle =
    TextStyle(color: Colors.white, fontSize: 14.sp);

class PayNowDialog {
  final NFT nft;
  final PurchaseItemViewModel purchaseItemViewModel;
  final ValueChanged<String> onPurchaseDone;

  BuildContext buildContext;

  PayNowDialog(
      {required this.buildContext,
      required this.nft,
      required this.purchaseItemViewModel,
      required this.onPurchaseDone});

  void show() {
    showDialog(
        context: buildContext,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: PayNowWidget(
                nft: nft,
                purchaseItemViewModel: purchaseItemViewModel,
                onPurchaseDone: onPurchaseDone,
              ));
        });
  }
}

class PayNowWidget extends StatefulWidget {
  final NFT nft;
  final PurchaseItemViewModel purchaseItemViewModel;
  final ValueChanged<String> onPurchaseDone;

  const PayNowWidget(
      {Key? key,
      required this.nft,
      required this.purchaseItemViewModel,
      required this.onPurchaseDone})
      : super(key: key);

  @override
  State<PayNowWidget> createState() => _PayNowWidgetState();
}

class _PayNowWidgetState extends State<PayNowWidget> {
  @override
  Widget build(BuildContext context) {
    final fee = double.parse(widget.nft.price) * 0.1;
    final price = double.parse(widget.nft.price) - fee;

    return Container(
      color: Colors.black.withOpacity(0.7),
      height: isTablet ? 290.h : 340.h,
      margin:
          isTablet ? EdgeInsets.symmetric(horizontal: 30.w) : EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 60,
              width: 80,
              child: ClipPath(
                clipper: RightTriangleClipper(
                    orientation: enums.Orientation.Orientation_NW),
                child: const ColoredBox(
                  color: kDarkRed,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: SizedBox(
              height: 60,
              width: 80,
              child: ClipPath(
                clipper: RightTriangleClipper(
                    orientation: enums.Orientation.Orientation_SE),
                child: const ColoredBox(
                  color: kDarkRed,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: SizedBox(
                    height: 50.h,
                    width: 50.h,
                    child: CachedNetworkImage(
                      imageUrl: widget.nft.url,
                      width: 1.sw,
                      errorWidget: (a, b, c) => Center(
                          child: Text(
                        "unable_to_fetch_nft_item".tr(),
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                      height: 1.sh,
                      fit: BoxFit.fitHeight,
                      placeholder: (context, _) => Shimmer(
                        color: PylonsAppTheme.cardBackground,
                        child: Container(),
                      ),
                    ),
                  ),
                  title: Text(
                    widget.nft.name,
                    style: _titleTextStyle,
                    maxLines: 1,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${"created_by".tr()} ${widget.nft.creator}",
                        style: _subtitleTextStyle,
                      ),
                      if (widget.nft.owner.isNotEmpty)
                        Text(
                          "${"sold_by".tr()} ${widget.nft.owner}",
                          style: _subtitleTextStyle,
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                buildRow(
                  subtitle: widget.nft.ibcCoins.getAbbrev(),
                  title: "currency".tr(),
                ),
                SizedBox(
                  height: 3.h,
                ),
                buildRow(
                  subtitle: widget.nft.ibcCoins
                      .getCoinWithDenominationAndSymbol(price.toString(),
                          showDecimal: true),
                  title: "price".tr(),
                ),
                SizedBox(
                  height: 3.h,
                ),
                buildPylonsFeeRow(
                  subtitle: widget.nft.ibcCoins
                      .getCoinWithDenominationAndSymbol(fee.toString(),
                          showDecimal: true),
                  title: "pylons_fee".tr(),
                ),
                SizedBox(
                  height: 3.h,
                ),
                buildRow(
                  subtitle: widget.nft.ibcCoins
                      .getCoinWithDenominationAndSymbol(widget.nft.price,
                          showDecimal: true),
                  title: "total".tr(),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: PylonsPayWithSwipe(
                    activeColor: kDarkRed,
                    inactiveColor: kPayNowBackgroundGrey,
                    height: 40.h,
                    initialWidth: 40.w,
                    onSwipeComplete: () {
                      executeRecipe(context);
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildRow({required String title, required String subtitle}) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Text(
            title,
            style: _rowTitleTextStyle,
          ),
        )),
        Expanded(
            child: Text(
          subtitle,
          style: _rowSubtitleTextStyle,
        ))
      ],
    );
  }

  Row buildPylonsFeeRow({required String title, required String subtitle}) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: _rowTitleTextStyle,
              ),
              SizedBox(
                width: 5.w,
              ),
              InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                          content: Text("pylons_fee_msg".tr()),
                          margin: const EdgeInsets.all(10),
                          behavior: SnackBarBehavior.floating,
                        ))
                        .closed
                        .then((value) =>
                            ScaffoldMessenger.of(context).clearSnackBars());
                  },
                  child: SvgPicture.asset(
                    SVGUtil.i_icon,
                    color: kWhite,
                    fit: BoxFit.cover,
                  )),
            ],
          ),
        )),
        Expanded(
            child: Text(
          subtitle,
          style: _rowSubtitleTextStyle,
        ))
      ],
    );
  }

  Future<void> executeRecipe(BuildContext context) async {
    final ibcEnumCoins =
        widget.purchaseItemViewModel.nft.denom.toIBCCoinsEnum();
    switch (widget.nft.type) {
      case NftType.TYPE_RECIPE:
        if (ibcEnumCoins == IBCCoins.ustripeusd) {
          stripePaymentForRecipe(context, widget.nft);
        } else {
          paymentByCoins();
        }
        break;
      case NftType.TYPE_ITEM:
        break;
      case NftType.TYPE_TRADE:
        if (ibcEnumCoins == IBCCoins.ustripeusd) {
          stripePaymentForTrade(context, widget.nft);
        } else {
          widget.purchaseItemViewModel.paymentForTrade();
        }
        break;
    }
  }

  Future paymentByCoins() async {
    final executionResponse =
        await widget.purchaseItemViewModel.paymentForRecipe();

    Navigator.pop(navigatorKey.currentState!.overlay!.context);

    if (!executionResponse.success) {
      if (executionResponse.error.contains(kLOW_LOW_BALANCE_CONSTANT)) {
        final InsufficientBalanceDialog insufficientBalanceDialog =
            InsufficientBalanceDialog(
                navigatorKey.currentState!.overlay!.context);
        return insufficientBalanceDialog.show();
      }
      executionResponse.error.show();
      return;
    }

    widget.onPurchaseDone(executionResponse.data.toString());
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

    if (response.isLeft()) {
      response.swap().toOption().toNullable()?.message.show();
      return;
    }

    final pi_info =
        response.getOrElse(() => StripeCreatePaymentIntentResponse());

    if (pi_info.clientsecret.isEmpty) {
      return;
    }
    try {
      final pi =
          await Stripe.instance.retrievePaymentIntent(pi_info.clientsecret);

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              applePay: true,
              googlePay: true,
              style: ThemeMode.system,
              testEnv: baseEnv.baseStripeTestEnv,
              merchantCountryCode: kStripeMerchantCountry,
              merchantDisplayName: kStripeMerchantDisplayName,
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
          "cookbook_id": "",
          "recipe_id": "",
          "coin_inputs_index": 0,
          "payment_infos": []
        }
        ''';

      final jsonMap = jsonDecode(jsonExecuteRecipe) as Map;
      jsonMap[kCookbookIdKey] = nft.cookbookID;
      jsonMap["recipe_id"] = nft.recipeID;

      final paymentInfos = jsonMap["payment_infos"] as List<dynamic>;
      paymentInfos.add(receipt.toJson());

      final loader = Loading()..showLoading();

      final execution = await walletsStore.executeRecipe(jsonMap);
      loader.dismiss();

      Navigator.of(navigatorKey.currentState!.overlay!.context).pop();

      if (!execution.success) {
        execution.error.show();
        return;
      }

      widget.onPurchaseDone(execution.data.toString());
    } catch (error) {
      Navigator.pop(navigatorKey.currentState!.overlay!.context);
    }
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
                merchantCountryCode: kStripeMerchantCountry,
                merchantDisplayName: kStripeMerchantDisplayName,
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
        jsonMap["ID"] = nft.tradeID;
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

  void showLoading(BuildContext context) {
    Loading().showLoading();
  }
}
