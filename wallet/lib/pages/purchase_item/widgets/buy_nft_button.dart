import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/utils/constants.dart';
import '../../../generated/locale_keys.g.dart';
import '../clipper/top_left_bottom_right_clipper.dart';

class BuyNFTButton extends StatelessWidget {
  final VoidCallback onTapped;
  final NFT nft;

  const BuyNFTButton({Key? key, required this.onTapped, required this.nft}) : super(key: key);

  Widget getButtonContent(NFT nft, PurchaseItemViewModel viewModel) {
    final double btnHeight = 35.h;
    final double btnWidth = isTablet ? 160.w : 200.w;
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
            child: ClipPath(
              clipper: TopLeftBottomRightClipper(),
              child: ColoredBox(
                color: AppColors.kDarkRedColor,
                child: getMessageContent(),
              ),
            ),
          ),
          getPriceAndAvailability(nft),
        ],
      ),
    );
  }

  Expanded getPriceAndAvailability(NFT nft) {
    if (double.parse(nft.price) != 0) {
      return Expanded(
        flex: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                text: "\$${nft.ibcCoins.getCoinValueBasedOnDollar(nft.price)}",
                style: TextStyle(
                  color: AppColors.kWhite,
                  fontSize: 10.sp,
                  fontFamily: kUniversalFontFamily,
                  fontWeight: FontWeight.w700,
                ),
                children: [
                  TextSpan(
                    text: " ${LocaleKeys.ea.tr()}.",
                    style: TextStyle(
                      color: AppColors.kWhite,
                      fontSize: 10.sp,
                      fontFamily: kUniversalFontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
            Text(
              "${nft.quantity - nft.amountMinted} ${LocaleKeys.available.tr()}",
              style: TextStyle(
                color: AppColors.kGreyLight,
                fontSize: 9.sp,
                fontWeight: FontWeight.normal,
                fontFamily: kUniversalFontFamily,
              ),
            ),
          ],
        ),
      );
    }
    return Expanded(
      flex: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.remaining_and_total_editions.tr(
              namedArgs: {
                'remaining': '${nft.quantity - nft.amountMinted}',
                'total': '${nft.quantity}',
              },
            ),
            style: TextStyle(
              color: AppColors.kGreyLight,
              fontSize: 9.sp,
              fontWeight: FontWeight.normal,
              fontFamily: kUniversalFontFamily,
            ),
          ),
          Text(
            LocaleKeys.remaining.tr(),
            style: TextStyle(
              color: AppColors.kGreyLight,
              fontSize: 9.sp,
              fontWeight: FontWeight.normal,
              fontFamily: kUniversalFontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Center getMessageContent() {
    if (double.parse(nft.price) != 0) {
      return Center(
        child: AutoSizeText(
          LocaleKeys.buy_now.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.kWhite,
            fontSize: 12.sp,
            fontFamily: kUniversalFontFamily,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
        ),
      );
    }
    return Center(
      child: AutoSizeText(
        LocaleKeys.claim_now.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.kWhite,
          fontSize: 12.sp,
          fontFamily: kUniversalFontFamily,
          fontWeight: FontWeight.w700,
        ),
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<PurchaseItemViewModel>();
    return ClipPath(
      clipper: TopLeftBottomRightClipper(),
      child: InkWell(
        onTap: onTapped,
        child: getButtonContent(nft, viewModel),
      ),
    );
  }
}
