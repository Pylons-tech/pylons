import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;
import 'package:pylons_wallet/utils/svg_util.dart';
import 'package:url_launcher/url_launcher_string.dart' as url_launcher;

TextStyle _rowTitleTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: isTablet ? 10.sp : 14.sp);
TextStyle _rowSubtitleTextStyle = TextStyle(color: Colors.white, fontSize: isTablet ? 9.sp : 13.sp, fontWeight: FontWeight.w800);
TextStyle _rowBlueTextStyle = TextStyle(color: AppColors.kTradeReceiptTextColor, fontSize: isTablet ? 9.sp : 13.sp, fontWeight: FontWeight.w400);

class TradeReceiptDialog {
  final TradeReceiptModel _model;
  final BuildContext _buildContext;

  TradeReceiptDialog({required TradeReceiptModel model, required BuildContext context})
      : _model = model,
        _buildContext = context;

  void show() {
    showDialog(
        context: _buildContext,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: TradeReceiptWidget(
                model: _model,
              ));
        });
  }
}

class TradeReceiptWidget extends StatefulWidget {
  final TradeReceiptModel model;

  const TradeReceiptWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<TradeReceiptWidget> createState() => _TradeReceiptWidgetState();
}

class _TradeReceiptWidgetState extends State<TradeReceiptWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      height: isTablet ? 410.h : 430.h,
      margin: isTablet ? EdgeInsets.symmetric(horizontal: 30.w) : EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 60,
              width: 80,
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
              height: 60,
              width: 80,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                SvgPicture.asset(
                  SVGUtil.TRADE_CHECK,
                  height: 28.h,
                ),
                SizedBox(height: 15.h),
                SvgPicture.asset(
                  SVGUtil.TRADE_RECEIPT,
                  height: 20.h,
                ),
                SizedBox(height: 20.h),
                buildRowWithBlueSubtitle(subtitle: widget.model.createdBy, title: "created_by".tr()),
                SizedBox(height: 3.h),
                buildRowWithBlueSubtitle(subtitle: widget.model.soldBy, title: "sold_by".tr()),
                SizedBox(height: 20.h),
                buildRowWithElipses(
                  subtitle: widget.model.transactionID,
                  title: "tx_id".tr(),
                ),
                SizedBox(height: 3.h),
                buildRow(
                  subtitle: widget.model.transactionTime,
                  title: "transaction_time".tr(),
                ),
                SizedBox(height: 30.h),
                buildRow(
                  subtitle: widget.model.currency,
                  title: "currency".tr(),
                ),
                buildRow(
                  subtitle: widget.model.price,
                  title: "price".tr(),
                ),
                SizedBox(height: 3.h),
                buildRow(
                  subtitle: widget.model.pylonsFee,
                  title: "pylons_fee".tr(),
                ),
                SizedBox(height: 3.h),
                buildRow(
                  subtitle: widget.model.total,
                  title: "total".tr(),
                ),
                SizedBox(height: 30.h),
                Center(
                  child: ClipPath(
                    clipper: TradeReceiptClipper(),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 180.r,
                        height: 40.h,
                        color: AppColors.kPayNowBackgroundGrey.withOpacity(0.2),
                        child: Center(
                          child: Text(
                            "close".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildRow({required String title, required String subtitle}) {
    return Container(
      padding: EdgeInsets.only(left: 30.w, right: 20.w),
      child: Row(
        children: [
          SizedBox(
            width: 0.35.sw,
            child: Text(
              title,
              style: _rowTitleTextStyle,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
              flex: 2,
              child: Text(
                subtitle,
                style: _rowSubtitleTextStyle,
              ))
        ],
      ),
    );
  }

  InkWell buildRowWithElipses({required String title, required String subtitle}) {
    return InkWell(
      onTap: () {
        openTransactionInBigDipper(txId: subtitle);
      },
      child: Container(
        padding: EdgeInsets.only(left: 30.w, right: 20.w),
        child: Row(
          children: [
            SizedBox(
              width: 0.35.sw,
              child: Text(
                title,
                style: _rowTitleTextStyle,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      subtitle.substring(0, 4),
                      style: _rowSubtitleTextStyle,
                    ),
                    Text(
                      "...",
                      style: _rowSubtitleTextStyle,
                    ),
                    Text(
                      subtitle.substring(subtitle.length - 4, subtitle.length - 1),
                      style: _rowSubtitleTextStyle,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Row buildRowWithBlueSubtitle({required String title, required String subtitle}) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: Text(
                title,
                style: _rowTitleTextStyle,
              ),
            )),
        Expanded(
            flex: 2,
            child: Text(
              subtitle,
              style: _rowBlueTextStyle,
            ))
      ],
    );
  }

  void showLoading(BuildContext context) {
    Loading().showLoading();
  }

  Future openTransactionInBigDipper({required String txId}) async {
    url_launcher.launchUrlString("$kBigDipperTransactionViewingUrl$txId");
  }
}

class TradeReceiptModel {
  String createdBy;
  String soldBy;
  String tradeId;
  String transactionTime;
  String currency;
  String price;
  String pylonsFee;
  String total;
  String nftName;
  String transactionID;

  TradeReceiptModel(
      {required this.createdBy,
      required this.soldBy,
      required this.tradeId,
      required this.transactionTime,
      required this.currency,
      required this.price,
      required this.pylonsFee,
      required this.total,
      required this.transactionID,
      required this.nftName});
}

class TradeReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width - 18, size.height);
    path.lineTo(size.width, size.height - 18);
    path.lineTo(size.width, 0);
    path.lineTo(18, 0);
    path.lineTo(0, 18);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
