import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/locale_keys.g.dart';
import '../main.dart';

class EaselPriceInputField extends StatelessWidget {
  const EaselPriceInputField({
    Key? key,
    this.controller,
    this.validator,
    this.inputFormatters = const [],
  }) : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.price_per_edition.tr(),
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 4.h),
        Stack(
          children: [
            Positioned(
              child: Image.asset(
                PngUtils.kTextFieldSingleLine,
                width: 1.sw,
                height: isTablet ? 40.h : 35.h,
                fit: BoxFit.fill,
              ),
            ),
            TextFormField(
              style: TextStyle(
                fontSize: isTablet ? 13.sp : 14.sp,
                fontWeight: FontWeight.w400,
                color: EaselAppTheme.kDarkText,
              ),
              controller: controller,
              validator: validator,
              minLines: 1,
              keyboardType: TextInputType.number,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                hintText: LocaleKeys.enter_whole_dollar_amount.tr(),
                hintStyle: TextStyle(
                  fontSize: isTablet ? 13.sp : 14.sp,
                  fontWeight: FontWeight.w400,
                  color: EaselAppTheme.kGrey,
                ),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 0.h),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
