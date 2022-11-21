import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/toggle_button.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

import '../../../components/buttons/custom_paint_button.dart';
import '../../../components/no_internet.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;

import '../../home/wallet_screen/widgets/currency_card.dart';
import '../../home/wallet_screen/widgets/what_is_pylon_dialog.dart';
import '../../presenting_onboard_page/components/custom_clipper_text_field.dart';
import 'buy_button.dart';



class ForSaleBottomSheet {
  BuildContext context;
  String amount;
  Function? onCallback;

  ForSaleBottomSheet({required this.context, required this.amount, this.onCallback});

  Future show() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        builder: (context) => const ForSaleBottomSheetWidget()
    );
  }
}


class ForSaleBottomSheetWidget extends StatefulWidget {
  const ForSaleBottomSheetWidget({Key? key}) : super(key: key);

  @override
  State<ForSaleBottomSheetWidget> createState() => _ForSaleBottomSheetWidgetState();
}

class _ForSaleBottomSheetWidgetState extends State<ForSaleBottomSheetWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              child: Image.asset(ImageUtil.CLOSE_ICON,width: 25.w,height: 25.h,),
            ),
          ),
          Align(
            child: Text(
              LocaleKeys.sell_your_nft.tr(),
              style: TextStyle(
                color: AppColors.kDarkPurple,
                fontSize: 15.sp,
                fontFamily: kUniversalFontFamily,
                fontWeight: FontWeight.w800
              ),
            ),
          ),
          SizedBox(height: 20.h,),
          Text(
            LocaleKeys.payment_type.tr(),
            style: TextStyle(
                color: AppColors.kDarkPurple,
                fontSize: 12.sp,
                fontFamily: kUniversalFontFamily,
                fontWeight: FontWeight.w800
            ),
          ),
          SizedBox(height: 10.h,),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.kDarkPurple,
                width: 3
              ),
            ),
            padding: const EdgeInsets.all(3),
            child: Row(
              children: [
                Expanded(
                  child: ClipPath(
                    clipper: ToggleClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.kDarkPurple
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 7.h),
                      child: Text(
                        LocaleKeys.credits.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.kWhite,),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 1.w,),
                Expanded(
                  child: ClipPath(
                    clipper: BottomLeftCurvedCorner(cuttingEdge: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.kDarkPurple
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 7.h),
                      child: Text(
                        LocaleKeys.cash,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.kWhite,),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h,),
          Text(
            LocaleKeys.payment_type.tr(),
            style: TextStyle(
                color: AppColors.kDarkPurple,
                fontSize: 12.sp,
                fontFamily: kUniversalFontFamily,
                fontWeight: FontWeight.w800
            ),
          ),

        ],
      ),
    );
  }
}

