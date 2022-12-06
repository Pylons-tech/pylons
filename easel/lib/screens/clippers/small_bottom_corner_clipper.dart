import 'package:flutter/cupertino.dart';

class RightSmallBottomClipper extends CustomClipper<Path> {
  double cuttingEdgeValue;
  RightSmallBottomClipper({this.cuttingEdgeValue = 0});

  @override
  Path getClip(Size size) {
    if(cuttingEdgeValue == 0){
      cuttingEdgeValue = size.width * 0.2;
    }
    final Path path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width - cuttingEdgeValue, size.height)
      ..lineTo(size.width, size.height - cuttingEdgeValue)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
