import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/trade_receipt_dialog.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;
import 'package:pylons_wallet/utils/svg_util.dart';

TextStyle _rowTitleTextStyle = TextStyle(
    color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.sp);

class TradeCompleteDialog {
  final TradeReceiptModel _model;
  final BuildContext _buildContext;
  final VoidCallback _onBackPressed;

  TradeCompleteDialog(
      {required TradeReceiptModel model,
      required BuildContext context,
      required VoidCallback onBackPressed})
      : _model = model,
        _buildContext = context,
        _onBackPressed = onBackPressed;

  void show() {
    showDialog(
        context: _buildContext,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: TradeCompleteWidget(
                model: _model,
                onBackPressed: _onBackPressed,
              ));
        });
  }
}

class TradeCompleteWidget extends StatefulWidget {
  final TradeReceiptModel model;
  final VoidCallback onBackPressed;

  const TradeCompleteWidget(
      {Key? key, required this.model, required this.onBackPressed})
      : super(key: key);

  @override
  State<TradeCompleteWidget> createState() => _TradeCompleteWidgetState();
}

class _TradeCompleteWidgetState extends State<TradeCompleteWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      height: 200.h,
      margin:
          isTablet ? EdgeInsets.symmetric(horizontal: 30.w) : EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 60,
              width: 80,
              child: ClipPath(
                clipper: RightTriangleClipper(
                    orientation: enums.Orientation.Orientation_NW),
                child:  ColoredBox(
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
                clipper: RightTriangleClipper(
                    orientation: enums.Orientation.Orientation_SE),
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
                SizedBox(
                  height: 20.h,
                ),
                SvgPicture.asset(
                  SVGUtil.TRANSACTION_COMPLETE,
                  height: isTablet ? 24.h : null,
                ),
                SizedBox(
                  height: 25.h,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: isTablet ? 20.w : 30.w),
                  child: Text(
                    "transaction_complete_desc"
                        .tr(args: [widget.model.nftName]),
                    style: _rowTitleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                  child: ClipPath(
                    clipper: TradeReceiptClipper(),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onBackPressed.call();
                      },
                      child: Container(
                        width: 180.r,
                        height: 40.h,
                        color: AppColors.kPayNowBackgroundGrey.withOpacity(0.2),
                        child: Center(
                          child: Text(
                            "view_receipt".tr(),
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TradeCompleteClipper extends CustomClipper<Path> {
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
