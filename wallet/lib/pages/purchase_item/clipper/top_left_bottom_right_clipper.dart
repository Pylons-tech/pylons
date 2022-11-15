import 'package:flutter/material.dart';

class TopLeftBottomRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, 18);
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
