import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/screen_responsive.dart';

class EaselTextField extends StatelessWidget {
  const EaselTextField(
      {Key? key,
      required this.label,
      this.hint = "",
      this.controller,
      this.validator,
      this.noOfLines = 1, // default to single line
      this.inputFormatters = const [],
      this.keyboardType = TextInputType.text,
      this.textCapitalization = TextCapitalization.none})
      : super(key: key);

  final String label;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int noOfLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 4.h),
        Stack(
          children: [
            ScreenResponsive(
              mobileScreen: (context) => Image.asset(
                noOfLines == 1 ? PngUtils.kTextFieldSingleLine : PngUtils.kTextFieldMultiLine,
                height: noOfLines == 1 ? 40.h : 95.h,
                width: 1.sw,
                fit: BoxFit.fill,
              ),
              tabletScreen: (context) => Image.asset(
                noOfLines == 1 ? PngUtils.kTextFieldSingleLine : PngUtils.kTextFieldMultiLine,
                height: noOfLines == 1 ? 40.h : 100.h,
                width: 1.sw,
                fit: BoxFit.fill,
              ),
            ),
            ScreenResponsive(mobileScreen: (_) => buildMobileTextField(), tabletScreen: (_) => buildTabletTextField()),
          ],
        ),
      ],
    );
  }

  SizedBox buildMobileTextField() {
    return SizedBox(
      height: noOfLines == 1 ? 40.h : 95.h,
      child: Align(
        child: TextFormField(
          style: TextStyle(
            fontSize: noOfLines == 1 ? 14.sp : 15.sp,
            fontWeight: FontWeight.w400,
            color: EaselAppTheme.kDarkText,
          ),
          controller: controller,
          validator: validator,
          minLines: noOfLines,
          maxLines: noOfLines,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: EaselAppTheme.kGrey,
            ),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
          ),
        ),
      ),
    );
  }

  SizedBox buildTabletTextField() {
    return SizedBox(
      height: noOfLines == 1 ? 40.h : 100.h,
      child: Align(
        child: TextFormField(
          style: TextStyle(
            fontSize: noOfLines == 1 ? 13.sp : 12.sp,
            fontWeight: FontWeight.w400,
            color: EaselAppTheme.kDarkText,
          ),
          controller: controller,
          validator: validator,
          minLines: noOfLines,
          maxLines: noOfLines,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: noOfLines == 1 ? 13.sp : 14.sp, color: EaselAppTheme.kGrey),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
          ),
        ),
      ),
    );
  }
}
