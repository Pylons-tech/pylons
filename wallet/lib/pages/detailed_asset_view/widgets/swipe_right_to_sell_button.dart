import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../utils/constants.dart';
import '../../purchase_item/widgets/pay_with_swipe.dart';

class SwipeRightToSellButton extends StatefulWidget {
  final Color activeColor;
  final double height;
  final double initialWidth;
  final VoidCallback onSwipeComplete;
  final bool isEnabled;

  const SwipeRightToSellButton({
    Key? key,
    required this.activeColor,
    required this.height,
    required this.initialWidth,
    required this.onSwipeComplete,
    required this.isEnabled,
  }) : super(key: key);

  @override
  State<SwipeRightToSellButton> createState() => _SwipeRightToSellButtonState();
}

class _SwipeRightToSellButtonState extends State<SwipeRightToSellButton> {
  double left = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipPath(
        clipper: PayNowClipper(),
        child: LayoutBuilder(builder: (context, constraint) {
          return Container(
            color: widget.activeColor.withOpacity(0.2),
            height: widget.height,
            width: constraint.maxWidth,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onHorizontalDragUpdate: widget.isEnabled
                        ? (details) {
                            setState(() {
                              if (details.globalPosition.dx > widget.initialWidth && ((left + widget.initialWidth) < constraint.maxWidth)) {
                                left = details.globalPosition.dx - widget.initialWidth;
                              }
                            });
                          }
                        : null,
                    onHorizontalDragEnd: widget.isEnabled
                        ? (details) {
                            if ((left + widget.initialWidth) >= constraint.maxWidth * 0.9) {
                              widget.onSwipeComplete();
                            }
                          }
                        : null,
                    child: ClipPath(
                      clipper: PayNowClipper(),
                      child: Container(
                        height: 40.h,
                        width: 40.w + left,
                        color: widget.activeColor,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 40.w,
                            width: 40.w,
                            child: Visibility(
                              visible: !((left + widget.initialWidth) >= constraint.maxWidth * 0.9),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Text(
                        LocaleKeys.swipe_right_to_sell.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: (left > constraint.maxWidth * 0.3) ? AppColors.kWhite : widget.activeColor,
                          fontSize: 14.sp,
                          fontFamily: kUniversalFontFamily,
                          fontWeight: widget.isEnabled?FontWeight.w700:FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
