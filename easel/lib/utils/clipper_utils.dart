import 'package:flutter/material.dart';
import 'package:easel_flutter/utils/enums.dart' as enums;

class ExpandedViewClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 30);
    path.lineTo(30, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 50);
    path.lineTo(size.width - 50, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class RightTriangleOwnerViewClipper extends CustomClipper<Path> {
  final enums.Orientation orientation;

  RightTriangleOwnerViewClipper({required this.orientation});

  @override
  Path getClip(Size size) {
    final path = Path();

    switch (orientation) {
      case enums.Orientation.Orientation_SW:
        path.lineTo(size.width, size.height);
        path.lineTo(size.width, 0);
        break;
      case enums.Orientation.Orientation_SE:
        path.lineTo(0, size.height);
        path.lineTo(size.width, 0);
        break;
      case enums.Orientation.Orientation_NW:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;
      case enums.Orientation.Orientation_NE:
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}

class MnemonicClipper extends CustomClipper<Path> {
  final double cuttingHeight;

  MnemonicClipper({required this.cuttingHeight});

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

class BoxShadowPainter extends CustomPainter {
  final double cuttingHeight;

  BoxShadowPainter({required this.cuttingHeight});

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
