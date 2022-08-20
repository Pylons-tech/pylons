import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  const VerticalSpace(this.height);
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class HorizontalSpace extends StatelessWidget {
  const HorizontalSpace(this.width);
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
