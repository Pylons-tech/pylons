import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/constants.dart';

TextStyle kPylonLabelText = TextStyle(fontSize: 18.sp, fontFamily: kUniversalFontFamily, color: AppColors.kTextBlackColor, fontWeight: FontWeight.w800);
TextStyle kTitleText = TextStyle(fontSize: 15.sp, fontFamily: kUniversalFontFamily, color: AppColors.kBlack, fontWeight: FontWeight.w700);
TextStyle kSubTitleText = TextStyle(fontSize: 13.sp, fontFamily: kUniversalFontFamily, color: AppColors.kPriceTagColor, fontWeight: FontWeight.w700);

class AddPylonScreen extends StatefulWidget {
  const AddPylonScreen({Key? key}) : super(key: key);

  @override
  State<AddPylonScreen> createState() => _AddPylonScreenState();
}

class _AddPylonScreenState extends State<AddPylonScreen> {
  Repository get repository => GetIt.I.get();

  BaseEnv get baseEnv => GetIt.I.get();

  @override
  void initState() {
    super.initState();
    repository.logUserJourney(screenName: AnalyticsScreenEvents.addPylon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
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
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.kUserInputTextColor,
                  )),
            ),
            Column(
              children: [
                SizedBox(
                  height: 80.h,
                ),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => buildBuyRow(
                              svgAsset: baseEnv.skus[index].getSvgAsset(),
                              pylonText: baseEnv.skus[index].pylons,
                              bonusText: baseEnv.skus[index].bonus,
                              subtitle: baseEnv.skus[index].subtitle,
                              onPressed: () async {
                                buyProduct(itemId: baseEnv.skus[index].id);
                              },
                            ),
                        separatorBuilder: (_, __) => SizedBox(
                              height: 30.h,
                            ),
                        itemCount: baseEnv.skus.length)),
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
            style: kSubTitleText.copyWith(color: AppColors.kSubtitleColor),
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
              color: AppColors.kDarkRed,
              height: 30.h,
              width: 100.w,
              child: Center(
                  child: Text(
                "buy".tr(),
                style: kTitleText.copyWith(color: AppColors.kWhite),
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
        loading.dismiss();
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
      log(e.toString());
    }
  }
}
