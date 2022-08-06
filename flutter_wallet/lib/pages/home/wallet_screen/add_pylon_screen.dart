
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

TextStyle kPylonLabelText = TextStyle(fontSize: 18.sp, fontFamily: kUniversalFontFamily, color: kTextBlackColor, fontWeight: FontWeight.w800);
TextStyle kTitleText = TextStyle(fontSize: 15.sp, fontFamily: kUniversalFontFamily, color: kBlack, fontWeight: FontWeight.w700);
TextStyle kSubTitleText = TextStyle(fontSize: 13.sp, fontFamily: kUniversalFontFamily, color: kPriceTagColor, fontWeight: FontWeight.w700);

class AddPylonScreen extends StatefulWidget {
  const AddPylonScreen({Key? key}) : super(key: key);

  @override
  State<AddPylonScreen> createState() => _AddPylonScreenState();
}

class _AddPylonScreenState extends State<AddPylonScreen> {
  Repository get repository => GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top + 30.h,
          left: 15.w,
          right: 15.w,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "add_pylons".tr(),
                style: kPylonLabelText,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: kUserInputTextColor,
                  )),
            ),
            Column(
              children: [
                SizedBox(
                  height: 80.h,
                ),
                buildBuyRow(
                  svgAsset: SVGUtil.PYLON_ONE_CURRENCY,
                  pylonText: kBuyPylonOne,
                  bonusText: "",
                  subtitle: kOneUSD,
                  onPressed: () async {
                    buyProduct(itemId: kPylons1);
                  },
                ),
                SizedBox(
                  height: 30.h,
                ),
                buildBuyRow(
                  svgAsset: SVGUtil.PYLON_THREE_CURRENCY,
                  pylonText: kBuyPylonThree,
                  bonusText: "bonus_five".tr(),
                  subtitle: kThreeUSD,
                  onPressed: () async {
                    buyProduct(itemId: kPylons3);
                  },
                ),
                SizedBox(
                  height: 40.h,
                ),
                buildBuyRow(
                  svgAsset: SVGUtil.PYLON_FIVE_CURRENCY,
                  pylonText: kBuyPylonFive,
                  bonusText: "bonus_ten".tr(),
                  subtitle: kFiveUSD,
                  onPressed: () {
                    buyProduct(itemId: kPylons5);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBuyRow({required String svgAsset, required String pylonText, required String bonusText, required String subtitle, required VoidCallback onPressed}) {
    return Row(children: [
      SizedBox(
        height: 40.h,
        width: 40.h,
        child: SvgPicture.asset(
          svgAsset,
        ),
      ),
      SizedBox(
        width: 15.w,
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(
              text: TextSpan(text: pylonText, style: kTitleText, children: [
            TextSpan(
              text: "  $bonusText",
              style: kSubTitleText,
            )
          ])),
          SizedBox(
            width: 5.h,
          ),
          Text(
            subtitle,
            style: kSubTitleText.copyWith(color: kSubtitleColor),
          ),
        ]),
      ),
      InkWell(
        onTap: onPressed,
        child: CustomPaint(
          painter: BoxShadowPainter(cuttingHeight: 13.h),
          child: ClipPath(
            clipper: MnemonicClipper(cuttingHeight: 13.h),
            child: Container(
              color: kDarkRed,
              height: 30.h,
              width: 100.w,
              child: Center(
                  child: Text(
                "buy".tr(),
                style: kTitleText.copyWith(color: kWhite),
                textAlign: TextAlign.center,
              )),
            ),
          ),
        ),
      ),
    ]);
  }

  Future<void> buyProduct({required String itemId}) async {
    try {
      final loading = Loading();
      loading.showLoading();
      final inAppPurchaseResponse = await repository.isInAppPurchaseAvailable();

      if (inAppPurchaseResponse.isLeft()) {
        inAppPurchaseResponse.swap().toOption().toNullable()!.message.show();
        return;
      }
      final productsListResponse = await repository.getProductsForSale(itemId: itemId);
      loading.dismiss();

      if (productsListResponse.isLeft()) {
        productsListResponse.swap().toOption().toNullable()!.message.show();
        return;
      }
      final buyProductResponse = await repository.buyProduct(productsListResponse.toOption().toNullable()!);
      if (buyProductResponse.isLeft()) {
        buyProductResponse.swap().toOption().toNullable()!.message.show();
        return;
      }
    } catch (e) {
      e.toString().show();
      print(e);
    }
  }
}
