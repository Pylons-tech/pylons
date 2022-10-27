import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/purchase_item/clipper/buy_now_clipper.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/extension.dart';

class BuyNFTButton extends StatelessWidget {
  final VoidCallback onTapped;
  final NFT nft;

  const BuyNFTButton({Key? key, required this.onTapped, required this.nft}) : super(key: key);

  Widget getButtonContent(NFT nft, PurchaseItemViewModel viewModel) {
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
      height: isTablet ? 65.h : 55.h,
      width: isTablet ? 160.w : 200.w,
      color: AppColors.kDarkRed.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              viewModel.nft.ibcCoins.getAssets(),
              Text(
                "${"buy_for".tr()} ${viewModel.nft.ibcCoins.getCoinWithProperDenomination(viewModel.nft.price)} ${viewModel.nft.ibcCoins.getTrailingAbbrev()} ",
                style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (viewModel.nft.ibcCoins.name == kPylonDenom)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0.w),
              child: Text(
                "(\$${viewModel.nft.ibcCoins.name.convertPylonsToUSD(viewModel.nft.price)} $kStripeUSD_ABR)",
                style: TextStyle(color: Colors.white, fontSize: 13.sp),
              ),
            )
          else
            const SizedBox(),
          SizedBox(
            height: 2.0.h,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<PurchaseItemViewModel>();
    return ClipPath(
      clipper: BuyClipper(),
      child: InkWell(
        onTap: onTapped,
        child: getButtonContent(nft, viewModel),
      ),
    );
  }
}
