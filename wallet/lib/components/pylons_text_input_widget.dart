import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/pages/presenting_onboard_page/components/custom_clipper_text_field.dart';
import 'package:pylons_wallet/utils/constants.dart';

class PylonsTextInput extends StatelessWidget {
  const PylonsTextInput(
      {Key? key,
      required this.controller,
      required this.label,
      this.disabled = false,
      this.inputType = TextInputType.text,
      this.errorText})
      : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool disabled;
  final TextInputType inputType;
  final String? Function(String?)? errorText;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PylonsLongRightBottomClipper(),
      child: Container(
        color: AppColors.textFieldGreyColor,
        height: 35.h,
        child: Center(
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.black, fontSize: 16.sp),
            decoration: InputDecoration(
                enabled: !disabled,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                errorStyle: TextStyle(fontSize: 12.sp)),
            keyboardType: inputType,
            validator: errorText,
          ),
        ),
      ),
    );
  }
}
