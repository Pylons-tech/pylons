import 'dart:convert';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/model/stripe_create_payment_intent_request.dart';
import 'package:pylons_wallet/model/stripe_create_payment_intent_response.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_request.dart';
import 'package:pylons_wallet/model/stripe_generate_payment_receipt_response.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/execution.pb.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/pay_with_swipe.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

TextStyle _titleTextStyle = TextStyle(color: Colors.white, fontSize: 30.sp, fontWeight: FontWeight.w700);
TextStyle _rowTitleTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.sp);
TextStyle _rowSubtitleTextStyle = TextStyle(color: Colors.white, fontSize: 14.sp);

class PayNowDialog {
  final NFT nft;
  final PurchaseItemViewModel purchaseItemViewModel;
  final ValueChanged<Execution> onPurchaseDone;
  final bool shouldBuy;

  BuildContext buildContext;

  PayNowDialog({required this.buildContext, required this.nft, required this.purchaseItemViewModel, required this.onPurchaseDone, required this.shouldBuy});

  void show() {
    showDialog(
      context: buildContext,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ChangeNotifierProvider<PurchaseItemViewModel>.value(
            value: purchaseItemViewModel,
            builder: (context, snapshot) {
              return PayNowWidget(
                nft: nft,
                onPurchaseDone: onPurchaseDone,
                shouldBuy: shouldBuy,
              );
            },
          ),
        );
      },
    );
  }
}

class PayNowWidget extends StatefulWidget {
  final NFT nft;
  final ValueChanged<Execution> onPurchaseDone;
  final bool shouldBuy;

  const PayNowWidget({Key? key, required this.nft, required this.onPurchaseDone, required this.shouldBuy}) : super(key: key);

  @override
  State<PayNowWidget> createState() => _PayNowWidgetState();
}

class _PayNowWidgetState extends State<PayNowWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      // height: isTablet ? 390.h : 390.h,
      height: 390.h,
      margin: isTablet ? EdgeInsets.symmetric(horizontal: 30.w) : EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: SizedBox(
              height: 60,
              width: 80,
              child: ClipPath(
                clipper: RightTriangleClipper(orientation: enums.Orientation.Orientation_SW),
                child: Container(
                  color: AppColors.kDarkRed,
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SizedBox(
                        height: isTablet ?  25.h : 40.h,
                        width: isTablet ? 25.w : 40.w,
                        child: const Icon(Icons.cancel_sharp, color: Colors.white,)
                    ),
                  ),
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
                SizedBox(
                  height: 60.h,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Text("checkout".tr(), style: _titleTextStyle)),
                SizedBox(
                  height: 30.h,
                ),
                buildRow(
                  subtitle: widget.nft.name,
                  title: "NFT",
                ),
                SizedBox(
                  height: 3.h,
                ),
                buildRow(
                  subtitle: "#${widget.nft.amountMinted} of ${widget.nft.quantity}",
                  title: "edition".tr(),
                ),
                SizedBox(
                  height: 3.h,
                ),
                buildRow(
                  subtitle: widget.nft.type == NftType.TYPE_RECIPE ? widget.nft.creator : widget.nft.owner,
                  subtitleTextColor: AppColors.kTradeReceiptTextColor,
                  title: "artist".tr(),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Text('price'.tr(), style: _rowTitleTextStyle,)),
                SizedBox(
                  height: 3.h,
                ),
                _buildPriceView(),
                SizedBox(
                  height: 60.h,
                ),
                if (!widget.shouldBuy)
                  Center(
                    child: buildButton(
                        title: "add_pylons".tr(),
                        bgColor: AppColors.kDarkRed,
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          navigator.pop();
                          navigator.pushNamed(RouteUtil.ROUTE_ADD_PYLON);
                        }),
                  ),
                if (widget.shouldBuy)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: PylonsPayWithSwipe(
                      activeColor: AppColors.kDarkRed,
                      inactiveColor: AppColors.kPayNowBackgroundGrey,
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
  Widget buildRow({required String title, required String subtitle, Color subtitleTextColor = Colors.white}) {
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: subtitleTextColor, fontSize: 14.sp),
        ),),
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
                        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
                  },
                  child: SvgPicture.asset(
                    SVGUtil.i_icon,
                    color: AppColors.kWhite,
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

  Widget buildButton({required String title, required Color bgColor, required Function onPressed}) {
    return SizedBox(
      height: 40.h,
      child: InkWell(
        onTap: () => onPressed(),
        child: CustomPaint(
          painter: BoxShadowPainter(cuttingHeight: 18.h),
          child: ClipPath(
            clipper: MnemonicClipper(cuttingHeight: 18.h),
            child: Container(
              color: bgColor,
              height: 40.h,
              width: 200.w,
              child: Center(
                  child: Text(
                title,
                style: TextStyle(color: AppColors.kWhite, fontSize: isTablet ? 14.sp : 16.sp, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceView() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Row(
        children: [
          Expanded(flex: 2, child: Container(
            height: 40.h,
            color: AppColors.kDarkRed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 15.w,
                    height: 15.w,
                    child: widget.nft.ibcCoins.getAssets()),
                SizedBox(width: 3.w),
                Text(widget.nft.ibcCoins.getAbbrev(),  style: TextStyle(fontSize: 10.sp, color: Colors.white),),
              ],
            ),),),
          Expanded(flex: 3, child: Container(
            height: 40.h,
            color: AppColors.kGreyColor, child: Center(
            child: AutoSizeText(widget.nft.ibcCoins.getCoinWithProperDenomination(widget.nft.price),
              maxLines: 1,
              style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w700),),
          ),),),
        ],
      ),
    );
  }

  Future<void> executeRecipe(BuildContext context) async {
    final provider = context.read<PurchaseItemViewModel>();
    final ibcEnumCoins = provider.nft.denom.toIBCCoinsEnum();
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
          provider.paymentForTrade();
        }
        break;
    }
  }

  Future<void> paymentByCoins() async {
    final provider = context.read<PurchaseItemViewModel>();
    final executionResponse = await provider.paymentForRecipe();

    Navigator.pop(navigatorKey.currentState!.overlay!.context);
    if (!executionResponse.success) {
      executionResponse.error.show();
      Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamed(RouteUtil.ROUTE_FAILURE);
      return;
    }

    widget.onPurchaseDone(executionResponse.data!);
  }

  Future<void> stripePaymentForRecipe(BuildContext context, NFT nft) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final repository = GetIt.I.get<Repository>();
    final baseEnv = GetIt.I.get<BaseEnv>();
    showLoading(context);

    final response = await repository.CreatePaymentIntent(
        StripeCreatePaymentIntentRequest(productID: "recipe/${nft.cookbookID}/${nft.recipeID}", coinInputIndex: 0, address: walletsStore.getWallets().value.last.publicAddress));

    if (response.isLeft()) {
      response.swap().toOption().toNullable()?.message.show();
      return;
    }

    final pi_info = response.getOrElse(() => StripeCreatePaymentIntentResponse());

    if (pi_info.clientsecret.isEmpty) {
      return;
    }
    try {
      final pi = await Stripe.instance.retrievePaymentIntent(pi_info.clientsecret);

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              googlePay: PaymentSheetGooglePay(
                merchantCountryCode: kStripeMerchantCountry,
                testEnv: baseEnv.baseStripeTestEnv,
              ),
              applePay: const PaymentSheetApplePay(merchantCountryCode: kStripeMerchantCountry),
              style: ThemeMode.system,
              merchantDisplayName: kStripeMerchantDisplayName,
              paymentIntentClientSecret: pi_info.clientsecret));
      Navigator.pop(navigatorKey.currentState!.overlay!.context);
      await Stripe.instance.presentPaymentSheet();

      final receipt_response = await repository.GeneratePaymentReceipt(StripeGeneratePaymentReceiptRequest(paymentIntentID: pi.id, clientSecret: pi.clientSecret));

      if (receipt_response.isLeft()) {
        throw receipt_response.swap().toOption().toNullable()!;
      }

      final receipt = receipt_response.getOrElse(() => StripeGeneratePaymentReceiptResponse());

      const jsonExecuteRecipe = '''
        {
          "creator": "",
          "cookbook_id": "",
          "recipe_id": "",
          "coin_inputs_index": 0,
          "nftName": "",
          "nftPrice": "",
          "nftCurrency": "",
          "payment_infos": []
        }
        ''';

      final jsonMap = jsonDecode(jsonExecuteRecipe) as Map;
      jsonMap[kCookbookIdKey] = nft.cookbookID;
      jsonMap[kRecipeIdKey] = nft.recipeID;
      jsonMap[kNftName] = nft.name;
      jsonMap[kNftPrice] = nft.ibcCoins.getCoinWithProperDenomination(nft.price);
      jsonMap[kNftCurrency] = nft.ibcCoins.getAbbrev();

      final paymentInfos = jsonMap[kPaymentInfos] as List<dynamic>;
      paymentInfos.add(receipt.toJson());

      final loader = Loading()..showLoading();

      final executionResponse = await walletsStore.executeRecipe(jsonMap);
      loader.dismiss();

      Navigator.of(navigatorKey.currentState!.overlay!.context).pop();

      if (!executionResponse.success) {
        Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamed(RouteUtil.ROUTE_FAILURE);
        return;
      }

      widget.onPurchaseDone(executionResponse.data!);
    } catch (error) {
      Navigator.pop(navigatorKey.currentState!.overlay!.context);
    }
  }

  Future<void> stripePaymentForTrade(BuildContext context, NFT nft) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final repository = GetIt.I.get<Repository>();
    final baseEnv = GetIt.I.get<BaseEnv>();
    showLoading(context);
    final response =
        await repository.CreatePaymentIntent(StripeCreatePaymentIntentRequest(productID: "trade/${nft.tradeID}", coinInputIndex: 0, address: walletsStore.getWallets().value.last.publicAddress));
    final pi_info = response.getOrElse(() => StripeCreatePaymentIntentResponse());
    if (pi_info.clientsecret != "") {
      try {
        final pi = await Stripe.instance.retrievePaymentIntent(pi_info.clientsecret);

        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                style: ThemeMode.system,
                googlePay: PaymentSheetGooglePay(
                  merchantCountryCode: kStripeMerchantCountry,
                  testEnv: baseEnv.baseStripeTestEnv,
                ),
                applePay: const PaymentSheetApplePay(merchantCountryCode: kStripeMerchantCountry),
                merchantDisplayName: kStripeMerchantDisplayName,
                paymentIntentClientSecret: pi_info.clientsecret));
        Navigator.pop(navigatorKey.currentState!.overlay!.context);

        await Stripe.instance.presentPaymentSheet();

        final receipt_response = await repository.GeneratePaymentReceipt(StripeGeneratePaymentReceiptRequest(paymentIntentID: pi.id, clientSecret: pi.clientSecret));

        final receipt = receipt_response.getOrElse(() => StripeGeneratePaymentReceiptResponse());

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

        tradeResponse.success ? "purchase_nft_success".tr() : tradeResponse.error.show();
      } catch (error) {
        Navigator.pop(navigatorKey.currentState!.overlay!.context);
      }
    }
  }

  void showLoading(BuildContext context) {
    Loading().showLoading();
  }
}
