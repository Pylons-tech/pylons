import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PylonsPayWithSwipe extends StatefulWidget {
  final Color inactiveColor;
  final Color activeColor;
  final double height;
  final double initialWidth;
  final VoidCallback onSwipeComplete;

  const PylonsPayWithSwipe(
      {Key? key,
      required this.activeColor,
      required this.inactiveColor,
      required this.height,
      required this.initialWidth,
      required this.onSwipeComplete})
      : super(key: key);

  @override
  State<PylonsPayWithSwipe> createState() => _PylonsPayWithSwipeState();
}

class _PylonsPayWithSwipeState extends State<PylonsPayWithSwipe> {
  double left = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipPath(
        clipper: PayNowClipper(),
        child: LayoutBuilder(builder: (context, constraint) {
          return Container(
            color: widget.inactiveColor.withOpacity(0.2),
            height: widget.height,
            width: constraint.maxWidth,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        if (details.globalPosition.dx > widget.initialWidth &&
                            ((left + widget.initialWidth) <
                                constraint.maxWidth)) {
                          left =
                              details.globalPosition.dx - widget.initialWidth;
                        }
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      if ((left + widget.initialWidth) >=
                          constraint.maxWidth * 0.9) {
                        widget.onSwipeComplete();
                      }
                    },
                    child: ClipPath(
                      clipper: PayNowClipper(),
                      child: Container(
                        height: 40.h,
                        width: 40.w + left,
                        color: Colors.red,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                                height: 40.w,
                                width: 40.w,
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ))),
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
                        'swipe_right_to_pay'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      )),
                    )),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class PayNowClipper extends CustomClipper<Path> {
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
