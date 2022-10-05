import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/trade_receipt_dialog.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;
import 'package:pylons_wallet/utils/route_util.dart';

TextStyle _rowTitleTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13.sp);
TextStyle _headingTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30.sp);

class NftSoldDialog {
  final RemoteNotification _notification;
  final BuildContext _buildContext;

  NftSoldDialog({
    required RemoteNotification notification,
    required BuildContext context,
  })  : _notification = notification,
        _buildContext = context;

  void show() {
    showDialog(
        barrierDismissible: false,
        context: _buildContext,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: NftSoldContent(
                notification: _notification,
              ));
        });
  }
}

class NftSoldContent extends StatefulWidget {
  final RemoteNotification notification;

  const NftSoldContent({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  State<NftSoldContent> createState() => _NftSoldContentState();
}

class _NftSoldContentState extends State<NftSoldContent> {
  @override
  Widget build(BuildContext context) {
    final List<String> message = widget.notification.body!.split(kTo);

    return Container(
      color: Colors.black.withOpacity(0.7),
      height: 280.h,
      margin: isTablet ? EdgeInsets.symmetric(horizontal: 50.w) : EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 60.h,
              width: 60.h,
              child: ClipPath(
                clipper: RightTriangleClipper(orientation: enums.Orientation.Orientation_NW),
                child: ColoredBox(
                  color: AppColors.kDarkRed,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: SizedBox(
              height: 60.h,
              width: 60.h,
              child: ClipPath(
                clipper: RightTriangleClipper(orientation: enums.Orientation.Orientation_SE),
                child: ColoredBox(
                  color: AppColors.kDarkRed,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "nft_sold".tr(),
                    style: _headingTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.w : 30.w),
                    child: RichText(
                      text: TextSpan(text: "${message.first} to", style: _rowTitleTextStyle, children: [
                        TextSpan(
                          text: message.last,
                          style: _rowTitleTextStyle.copyWith(color: AppColors.kTradeReceiptTextColor),
                        )
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 60,
                        child: ClipPath(
                          clipper: TradeReceiptClipper(),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(RouteUtil.ROUTE_MESSAGE);
                            },
                            child: Container(
                              height: 40.h,
                              color: AppColors.kPayNowBackgroundGrey.withOpacity(0.2),
                              child: Center(
                                child: Text(
                                  "view_detail".tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 40,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "close".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
