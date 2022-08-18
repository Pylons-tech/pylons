import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ClipperType { topLeftBottomRight, bottomLeftTopRight }

class ClippedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color bgColor;
  final Color textColor;
  final double cuttingHeight;
  final ClipperType clipperType;
  final FontWeight fontWeight;
  bool? isShadow = true;

  ClippedButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.bgColor,
      required this.textColor,
      required this.cuttingHeight,
      this.isShadow = true,
      required this.clipperType,
      required this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed.call();
      },
      child: isShadow!
          ? CustomPaint(
              painter: clipperType == ClipperType.bottomLeftTopRight
                  ? BoxShadowPainterBottomLeftTopRight(
                      cuttingHeight: cuttingHeight)
                  : BoxShadowPainterTopLeftBottomRight(
                      cuttingHeight: cuttingHeight),
              child: ClipPath(
                clipper: clipperType == ClipperType.bottomLeftTopRight
                    ? ButtonClipperBottomLeftTopRight(
                        cuttingHeight: cuttingHeight)
                    : ButtonClipperTopLeftBottomRight(
                        cuttingHeight: cuttingHeight),
                child: Container(
                  color: bgColor,
                  height: 40.h,
                  child: Center(
                      child: Text(
                    title,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontWeight: fontWeight),
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
            )
          : ClipPath(
              clipper: clipperType == ClipperType.bottomLeftTopRight
                  ? ButtonClipperBottomLeftTopRight(
                      cuttingHeight: cuttingHeight)
                  : ButtonClipperTopLeftBottomRight(
                      cuttingHeight: cuttingHeight),
              child: Container(
                color: bgColor,
                height: 40.h,
                child: Center(
                    child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16.sp,
                    fontWeight: fontWeight,
                  ),
                  textAlign: TextAlign.center,
                )),
              ),
            ),
    );
  }
}

class ButtonClipperBottomLeftTopRight extends CustomClipper<Path> {
  final double cuttingHeight;
  ButtonClipperBottomLeftTopRight({required this.cuttingHeight});
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - cuttingHeight);
    path.lineTo(cuttingHeight, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, cuttingHeight);
    path.lineTo(size.width - cuttingHeight, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ButtonClipperTopLeftBottomRight extends CustomClipper<Path> {
  final double cuttingHeight;
  ButtonClipperTopLeftBottomRight({required this.cuttingHeight});
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, cuttingHeight);
    path.lineTo(cuttingHeight, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cuttingHeight);
    path.lineTo(size.width - cuttingHeight, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BoxShadowPainterBottomLeftTopRight extends CustomPainter {
  final double cuttingHeight;
  BoxShadowPainterBottomLeftTopRight({required this.cuttingHeight});
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - cuttingHeight);
    path.lineTo(cuttingHeight, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, cuttingHeight);
    path.lineTo(size.width - cuttingHeight, 0);
    path.lineTo(0, 0);

    canvas.drawShadow(path, Colors.black45, 10.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BoxShadowPainterTopLeftBottomRight extends CustomPainter {
  final double cuttingHeight;
  BoxShadowPainterTopLeftBottomRight({required this.cuttingHeight});
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, cuttingHeight);
    path.lineTo(cuttingHeight, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cuttingHeight);
    path.lineTo(size.width - cuttingHeight, size.height);
    path.lineTo(0, size.height);

    canvas.drawShadow(path, Colors.black45, 10.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
