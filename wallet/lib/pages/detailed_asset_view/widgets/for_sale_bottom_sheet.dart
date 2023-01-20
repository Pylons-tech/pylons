import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/swipe_right_to_sell_button.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/toggle_button.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/image_util.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../utils/constants.dart';
import '../../../utils/dollar_sign_formatter.dart';

class ForSaleBottomSheet {
  final OwnerViewViewModel ownerViewViewModel;
  BuildContext context;

  ForSaleBottomSheet({
    required this.ownerViewViewModel,
    required this.context,
  });

  Future show() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      builder: (context) => ChangeNotifierProvider.value(
        value: ownerViewViewModel,
        builder: (context, widget) {
          return Wrap(
            children: const [
              _ForSaleBottomSheetWidget(),
            ],
          );
        },
      ),
    );
  }
}

class _ForSaleBottomSheetWidget extends StatefulWidget {
  const _ForSaleBottomSheetWidget({Key? key}) : super(key: key);

  @override
  State<_ForSaleBottomSheetWidget> createState() => _ForSaleBottomSheetWidgetState();
}

class _ForSaleBottomSheetWidgetState extends State<_ForSaleBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    final ownerViewViewModel = context.watch<OwnerViewViewModel>();
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Container(
        key: const Key(kForSaleBottomSheetKey),
        padding: EdgeInsets.only(
          left: 18.w,
          right: 18.w,
          top: 10.h,
          bottom: 10.h + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  ImageUtil.CLOSE_ICON,
                  width: 25.w,
                  height: 25.h,
                ),
              ),
            ),
            Align(
              child: Text(
                LocaleKeys.sell_your_nft.tr(),
                style: TextStyle(
                  color: AppColors.kDarkPurple,
                  fontSize: 15.sp,
                  fontFamily: kUniversalFontFamily,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              LocaleKeys.payment_type.tr(),
              style: TextStyle(
                color: AppColors.kDarkPurple,
                fontSize: 12.sp,
                fontFamily: kUniversalFontFamily,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.kDarkPurple, width: 3),
              ),
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  Expanded(
                    child: ClipPath(
                      clipper: ToggleClipper(),
                      child: GestureDetector(
                        onTap: () {
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                          child: Text(
                            LocaleKeys.credits.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.kGreyColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  Expanded(
                    child: ClipPath(
                      clipper: BottomLeftCurvedCorner(cuttingEdge: 10),
                      child: GestureDetector(
                        onTap: () {
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.kTransparentColor,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                          child: Text(
                            LocaleKeys.cash.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.kGreyColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              LocaleKeys.no_of_editions.tr(),
              style: TextStyle(
                color: AppColors.kDarkPurple,
                fontSize: 12.sp,
                fontFamily: kUniversalFontFamily,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            ClipPath(
              clipper: ToggleClipper(),
              child: Container(
                width: double.maxFinite,
                height: 35.h,
                decoration: BoxDecoration(color: AppColors.kGreyLight),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                child: TextFormField(
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: AppColors.kTextBlackColor),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onChanged: (str) {

                  },
                  decoration: InputDecoration(
                    hintText: LocaleKeys.editions_are_sold_sequentially.tr(),
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.kUserInputTextColor,
                    ),
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 10.w, 0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${ownerViewViewModel.nft.quantity - ownerViewViewModel.nft.amountMinted} ${LocaleKeys.available.tr()}",
                style: TextStyle(
                  color: AppColors.kHashtagColor,
                  fontSize: 12.sp,
                  fontFamily: kUniversalFontFamily,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              LocaleKeys.price_per_edition.tr(),
              style: TextStyle(
                color: AppColors.kDarkPurple,
                fontSize: 12.sp,
                fontFamily: kUniversalFontFamily,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            ClipPath(
              clipper: ToggleClipper(),
              child: Container(
                width: double.maxFinite,
                height: 35.h,
                decoration: BoxDecoration(color: AppColors.kGreyLight),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                child: TextFormField(
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: AppColors.kTextBlackColor),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DollarSignFormatter(maxDigits: kMaxPriceLength),
                    LengthLimitingTextInputFormatter(kMaxPriceLength),
                  ],
                  decoration: InputDecoration(
                    hintText: LocaleKeys.enter_whole_dollar_amount.tr(),
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.kUserInputTextColor,
                    ),
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 10.w, 0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: LocaleKeys.network_fee_required.tr(),
                    style: TextStyle(
                      color: AppColors.kHashtagColor,
                      fontSize: 12.sp,
                      fontFamily: kUniversalFontFamily,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: " ${LocaleKeys.learn_more.tr()}",
                    style: TextStyle(color: AppColors.kEmoneyColor, fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 35.h,
            ),
            SwipeRightToSellButton(
              activeColor: AppColors.kDarkGreen,
              height: 40.h,
              initialWidth: 40.w,
              isEnabled: true,
              onSwipeComplete: () {

              },
            )
          ],
        ),
      ),
    );
  }
}
