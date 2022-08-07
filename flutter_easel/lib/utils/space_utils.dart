import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerticalSpace extends StatelessWidget {
  final double height;

 const VerticalSpace(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(height: height.h,);
}

class HorizontalSpace extends StatelessWidget {
  final double width;

  const HorizontalSpace(this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(width: width,);
}