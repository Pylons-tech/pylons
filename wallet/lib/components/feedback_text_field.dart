import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/screen_responsive.dart';

class FeedBackTextField extends StatelessWidget {
  const FeedBackTextField(
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
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.kBlack),
        ),
        SizedBox(height: 4.h),
        Stack(
          children: [
            ScreenResponsive(
              mobileScreen: (context) => Image.asset(
                isOneLine() ? ImageUtil.TextFieldSingleLine : ImageUtil.TextFieldMultiLine,
                height: isOneLine() ? 40.h : 120.h,
                width: 1.sw,
                fit: BoxFit.fill,
              ),
              tabletScreen: (context) => Image.asset(
                isOneLine() ? ImageUtil.TextFieldSingleLine : ImageUtil.TextFieldMultiLine,
                height: isOneLine() ? 32.h : 110.h,
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

  bool isOneLine() => noOfLines == 1;

  SizedBox buildMobileTextField() {
    return SizedBox(
      height: isOneLine() ? 40.h : 120.h,
      child: Align(
        child: TextFormField(
          style: TextStyle(fontSize: isOneLine() ? 18.sp : 15.sp, fontWeight: FontWeight.w400, color: AppColors.kTextBlackColor),
          controller: controller,
          validator: validator,
          minLines: noOfLines,
          maxLines: noOfLines,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: AppColors.kUserInputTextColor),
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
      height: isOneLine() ? 32.h : 110.h,
      child: Align(
        child: TextFormField(
          style: TextStyle(fontSize: isOneLine() ? 16.sp : 14.sp, fontWeight: FontWeight.w400, color: AppColors.kTextBlackColor),
          controller: controller,
          validator: validator,
          minLines: noOfLines,
          maxLines: noOfLines,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: isOneLine() ? 16.sp : 14.sp, color: AppColors.kUserInputTextColor),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
          ),
        ),
      ),
    );
  }
}
