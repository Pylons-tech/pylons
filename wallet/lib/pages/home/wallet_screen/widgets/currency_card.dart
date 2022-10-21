import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/model/transaction.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/model/currency.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/widgets/latest_transactions.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/widgets/what_is_pylon_dialog.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

class CurrencyBackgroundCard extends StatelessWidget {
  final bool isDefault;

  const CurrencyBackgroundCard({
    Key? key,
    required this.isDefault,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: SizedBox(
        height: isDefault ? 80.h : 60.h,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: -12.0.r,
                    blurRadius: 12.0.r,
                  ),
                ],
              ),
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                AppColors.kMainBG,
                AppColors.kMainBG,
                AppColors.kMainBG,
                AppColors.kMainBG,
                AppColors.kMainBG,
                Colors.grey.withOpacity(0.1),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyCard extends StatelessWidget {
  final Color? color;
  final bool isDefault;
  final Currency currencyModel;
  final VoidCallback onFaucetPressed;

  const CurrencyCard(
      {Key? key,
      required this.currencyModel,
      this.color,
      required this.isDefault,
      required this.onFaucetPressed})
      : super(key: key);

  Widget getHelpIcon(BuildContext context) {
    if (currencyModel.ibcCoins.getName() == kPylons) {
      return Align(
        alignment: Alignment.centerLeft,
        child: JustTheTooltip(
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Text(
              "what_is_pylon".tr(),
              style: TextStyle(
                  color: AppColors.kBlue, fontWeight: FontWeight.w500, fontSize: 12.sp),
            ),
          ),
          tailLength: 10,
          tailBaseWidth: 10,
          preferredDirection: AxisDirection.up,
          child: IconButton(
            iconSize: 15,
            alignment: Alignment.topLeft,
            color: Colors.white,
            onPressed: () {
              _showWhatIsPylonDialog(context);
            },
            icon: SvgPicture.asset(SVGUtil.INFO_ICON),
          ),
        ),
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    List<TransactionHistory> denomSpecificTxList = [];
    if (isDefault) {
      denomSpecificTxList = context
          .read<HomeProvider>()
          .getDenomSpecificTxList(defaultCurrency: currencyModel.currency);
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onFaucetPressed(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: CustomPaint(
              painter: _ClipShadowShadowPainter(
                  clipper: CurrencyCardClipper(),
                  shadow: Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0.0.w, 4.0.h),
                    blurRadius: 10.0.r,
                  )),
              child: ClipPath(
                clipper: CurrencyCardClipper(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  decoration: BoxDecoration(
                    color: currencyModel.ibcCoins.getColor(),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0.0.w, 4.0.h),
                        blurRadius: 10.0.r,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  child: Stack(
                    children: [
                      if (!isDefault) ...[
                        SizedBox(
                          width: double.infinity,
                          child: Image.asset(
                            ImageUtil.CURRENCY_BACKGROUND,
                            color: Colors.white,
                            height: 60.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.0.h),
                          child: Center(
                            child: Row(
                              children: [
                                currencyModel.ibcCoins.getAssets(),
                                SizedBox(width: 10.w),
                                Text(
                                  currencyModel.ibcCoins.getName(),
                                  style: kCurrencyStyle,
                                ),
                                const Spacer(),
                                Text(
                                  currencyModel.amount,
                                  style: kCurrencyStyle,
                                ),
                                SizedBox(width: 10.w),
                                Text(currencyModel.ibcCoins.getAbbrev(),
                                    style: kCurrencyStyle),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (isDefault)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 0.h), //20
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    currencyModel.ibcCoins.getAssets(),
                                    SizedBox(width: 10.w),
                                    Text(
                                      currencyModel.ibcCoins.getName(),
                                      style: kCurrencyStyle,
                                    ),
                                    getHelpIcon(context),
                                    const Spacer(),
                                    Text(
                                      currencyModel.amount,
                                      style: kCurrencyStyle,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(currencyModel.ibcCoins.getAbbrev(),
                                        style: kCurrencyStyle),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: isTablet ? 20.h : 15.h,
                                    width: 50.w,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4.h, horizontal: 8.0.w),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(4.0.r)),
                                    child: Center(
                                      child: Text(
                                        "default".tr(),
                                        style: TextStyle(
                                            color: AppColors.kBlue.withOpacity(0.5),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 8.sp),
                                      ),
                                    ),
                                    //)
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                if (denomSpecificTxList.isNotEmpty)
                                  LatestTransactions(
                                      denomSpecificTxList: denomSpecificTxList,
                                      defaultCurrency: currencyModel.currency),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showWhatIsPylonDialog(BuildContext context) {
    final WhatIsPylonDialog whatIsPylonDialog =
        WhatIsPylonDialog(context: context, onBackPressed: () {});
    whatIsPylonDialog.show();
  }
}

class CurrencyCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 20);
    path.lineTo(size.width - 20, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = shadow.toPaint();
    final clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
