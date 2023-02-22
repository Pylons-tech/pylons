import 'package:dartz/dartz.dart' show Either;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';

import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/swipe_right_to_sell_button.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/toggle_button.dart';
import 'package:pylons_wallet/providers/account_provider.dart';
import 'package:pylons_wallet/providers/items_provider.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/image_util.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../model/nft.dart';
import '../../../utils/constants.dart';
import '../../../utils/dollar_sign_formatter.dart';

class CreateTradeBottomSheet {
  CreateTradeBottomSheet({
    required this.context,
    required this.nft,
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
      builder: (context) => Wrap(
        children: [
          _CreateTradeBottomSheetWidget(
            nft: nft,
          )
        ],
      ),
    );
  }

  final BuildContext context;
  final NFT nft;
}

class _CreateTradeBottomSheetWidget extends StatefulWidget {
  final NFT nft;
  const _CreateTradeBottomSheetWidget({Key? key, required this.nft}) : super(key: key);

  @override
  State<_CreateTradeBottomSheetWidget> createState() => __CreateTradeBottomSheetWidgetState();
}

class __CreateTradeBottomSheetWidgetState extends State<_CreateTradeBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
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
                  onChanged: (str) {},
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
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Text(
            //     "${ownerViewViewModel.nft.quantity - ownerViewViewModel.nft.amountMinted} ${LocaleKeys.available.tr()}",
            //     style: TextStyle(
            //       color: AppColors.kHashtagColor,
            //       fontSize: 12.sp,
            //       fontFamily: kUniversalFontFamily,
            //       fontWeight: FontWeight.w800,
            //     ),
            //   ),
            // ),
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
                createTrade();
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> createTrade() async {
    final repository = GetIt.I.get<Repository>();

    final accountPublicInfo = context.read<AccountProvider>().accountPublicInfo;

    if (accountPublicInfo == null) {
      LocaleKeys.no_account_found.tr().show();
      return;
    }

    final recipeEither = await repository.getRecipe(
      cookBookId: widget.nft.cookbookID,
      recipeId: widget.nft.recipeID,
    );

    if (recipeEither.isLeft()) {
      return;
    }
    final recipe = recipeEither.getRight();

    final msgCreateTrade = MsgCreateTrade(
        creator: accountPublicInfo.publicAddress,
        coinInputs: recipe.coinInputs,
        extraInfo: recipe.extraInfo,
        itemOutputs: [
          ItemRef(
            cookbookId: widget.nft.cookbookID,
            itemId: widget.nft.itemID,
          ),
        ]);

    final tradeResponse = await repository.createTrade(msgCreateTrade: msgCreateTrade);

    if (tradeResponse.isLeft()) {
      tradeResponse.getLeft().message.show();
      return;
    }

    if (mounted) {
      context.read<ItemsProvider>()
        ..getItems()
        ..getTrades();
      Navigator.of(context).pop();
    }
  }
}

extension EitherHelper<T, R> on Either<T, R> {
  R getRight() {
    return toOption().toNullable()!;
  }

  T getLeft() {
    return swap().toOption().toNullable()!;
  }
}
