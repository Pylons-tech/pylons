import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/purchase_item/clipper/buy_now_clipper.dart';
import 'package:pylons_wallet/utils/constants.dart';

class BuyNFTButton extends StatelessWidget {
  final VoidCallback onTapped;
  final NFT nft;

  const BuyNFTButton({Key? key, required this.onTapped, required this.nft}) : super(key: key);

  Widget getButtonContent(NFT nft) {
    if (double.parse(nft.price) == 0) {
      return Container(
        height: 60.h,
        color: AppColors.kDarkRed.withOpacity(0.8),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                "claim_free_nft".tr(),
                maxLines: 1,
                style: TextStyle(color: AppColors.kWhite, fontSize: 16.sp, fontFamily: kUniversalFontFamily),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    "before_too_late".tr(),
                    maxLines: 1,
                    style: TextStyle(color: AppColors.kWhite, fontSize: 12.sp, fontFamily: kUniversalFontFamily),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: nft.ibcCoins.getAssets(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      height: 60.h,
      width: isTablet ? 160.w : 200.w,
      color: AppColors.kDarkRed.withOpacity(0.8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.w),
            alignment: Alignment.center,
            child: Container(
              height: 10.w,
              width: 10.w,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.kButtonBuyNowColor),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AutoSizeText(
                    "${"buy_for".tr()} ${nft.ibcCoins.getCoinWithProperDenomination(nft.price)}",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                nft.ibcCoins.getAssets(),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BuyClipper(),
      child: InkWell(
        onTap: onTapped,
        child: getButtonContent(nft),
      ),
    );
  }
}
