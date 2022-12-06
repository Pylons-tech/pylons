import 'package:flutter/cupertino.dart';

class BottomLeftCurvedCornerClipper extends CustomClipper<Path> {
  final double cuttingEdge;
  BottomLeftCurvedCornerClipper({required this.cuttingEdge});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height-cuttingEdge);
    path.lineTo(cuttingEdge, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
