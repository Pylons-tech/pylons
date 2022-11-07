import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

import '../../../generated/locale_keys.g.dart';
import '../clipper/top_left_bottom_right_clipper.dart';

class BuyNFTButton extends StatelessWidget {
  final VoidCallback onTapped;
  final NFT nft;

  const BuyNFTButton({Key? key, required this.onTapped, required this.nft}) : super(key: key);

  Widget getButtonContent(NFT nft) {
    final double btnHeight = 35.h;
    final double btnWidth = isTablet ? 160.w : 200.w;
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
                LocaleKeys.claim_free_nft.tr(),
                maxLines: 1,
                style: TextStyle(color: AppColors.kWhite, fontSize: 16.sp, fontFamily: kUniversalFontFamily),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    LocaleKeys.before_too_late.tr(),
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
      height: btnHeight,
      width: btnWidth,
      decoration: BoxDecoration(
        color: AppColors.kGreyLight.withOpacity(0.5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    SVGUtil.CURVED_CORNER_RED_BG,
                    height: btnHeight,
                    fit: BoxFit.fill,
                  ),
                ),
                Center(
                  child: AutoSizeText(
                    LocaleKeys.buy_now.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: kUniversalSans750FontFamily),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                      text: "\$${nft.ibcCoins.getCoinWithProperDenomination(nft.price)}",
                      style: TextStyle(color: AppColors.kWhite, fontSize: 12.sp, fontWeight: FontWeight.w500, fontFamily: kUniversalSans750FontFamily),
                      children: [
                        TextSpan(
                          text: " ${LocaleKeys.ea.tr()}.",
                          style: TextStyle(color: AppColors.kWhite, fontSize: 10.sp, fontWeight: FontWeight.normal, fontFamily: kUniversalSans750FontFamily),
                        )
                      ]),
                ),
                Text(
                  "${nft.quantity - nft.amountMinted} ${LocaleKeys.available.tr()}",
                  style: TextStyle(color: AppColors.kGreyLight, fontSize: 9.sp, fontWeight: FontWeight.normal, fontFamily: kUniversalFontFamily),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopLeftBottomRightClipper(),
      child: InkWell(
        onTap: onTapped,
        child: getButtonContent(nft),
      ),
    );
  }
}
