import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/screen_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventlyTextField extends StatelessWidget {
  const EventlyTextField({
    super.key,
    required this.label,
    this.hint = "",
    this.controller,
    this.validator,
    this.noOfLines = 1, // default to single line
    this.inputFormatters = const [],
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.enable,
    this.imageBackground,
    this.inputTextColor,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int noOfLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final TextCapitalization textCapitalization;

  final ValueChanged<String>? onChanged;
  final bool? enable;

  final String? imageBackground;
  final Color? inputTextColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 4.h),
        Stack(
          children: [
            ScreenResponsive(
              mobileScreen: (context) => Image.asset(
                imageBackground ?? (noOfLines == 1 ? PngUtils.kTextFieldSingleLine : PngUtils.kTextFieldMultiLine),
                height: noOfLines == 1 ? 40.h : 120.h,
                width: 1.sw,
                fit: BoxFit.fill,
              ),
              tabletScreen: (context) => Image.asset(
                imageBackground ?? (noOfLines == 1 ? PngUtils.kTextFieldSingleLine : PngUtils.kTextFieldMultiLine),
                height: noOfLines == 1 ? 32.h : 110.h,
                width: 1.sw,
                fit: BoxFit.fill,
              ),
            ),
            ScreenResponsive(mobileScreen: (_) => buildMobileTextField(enable), tabletScreen: (_) => buildTabletTextField(enable)),
          ],
        ),
      ],
    );
  }

  SizedBox buildMobileTextField(bool? enable) {
    return SizedBox(
      height: noOfLines == 1 ? 40.h : 120.h,
      child: Align(
        child: TextFormField(
          enabled: enable,
          onChanged: onChanged,
          style: TextStyle(fontSize: noOfLines == 1 ? 18.sp : 15, fontWeight: FontWeight.w400, color: inputTextColor ?? EventlyAppTheme.kTextGrey02),
          controller: controller,
          validator: validator,
          minLines: noOfLines,
          maxLines: noOfLines,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: inputTextColor ?? EventlyAppTheme.kTextGrey02),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
          ),
        ),
      ),
    );
  }

  SizedBox buildTabletTextField(bool? enable) {
    return SizedBox(
      height: noOfLines == 1 ? 32.h : 110.h,
      child: Align(
        child: TextFormField(
          enabled: enable,
          style: TextStyle(fontSize: noOfLines == 1 ? 16.sp : 14.sp, fontWeight: FontWeight.w400, color: EventlyAppTheme.kTextGrey),
          controller: controller,
          validator: validator,
          minLines: noOfLines,
          maxLines: noOfLines,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: noOfLines == 1 ? 16.sp : 14.sp, color: EventlyAppTheme.kTextGrey),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
          ),
        ),
      ),
    );
  }
}
