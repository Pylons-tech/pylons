import 'package:flutter/material.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;

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

class RightTriangleClipper extends CustomClipper<Path> {
  final enums.Orientation orientation;

  RightTriangleClipper({required this.orientation});

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

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomTriangleClipper oldClipper) => false;
}

class LeftRightTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.lineTo(0, size.height * 0.0714000);
    path0.lineTo(size.width * 0.0452000, 0);
    path0.lineTo(size.width * 0.9579000, size.height * 0.0004000);
    path0.lineTo(size.width, size.height * 0.0713000);
    path0.lineTo(size.width, size.height);
    path0.lineTo(0, size.height);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
