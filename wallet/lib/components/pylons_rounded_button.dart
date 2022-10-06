import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/utils/constants.dart';

class PylonsRoundedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final ImageProvider? glyph;
  final Color textColor;

  const PylonsRoundedButton({
    Key? key,
    this.glyph,
    required this.onTap,
    this.textColor = Colors.black,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipPath(
        clipper: MnemonicClipper(cuttingHeight: 18.h),
        child: Container(
          color: AppColors.kDarkRed,
          height: 45.h,
          width: 300.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildChildren(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildChildren() {
    final glyph = this.glyph;
    if (glyph != null) {
      return [
        Image(
          image: glyph,
          width: 22.w,
          fit: BoxFit.cover,
        ),
        const HorizontalSpace(10),
        Expanded(
          child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', color: textColor, fontSize: 16.sp, fontWeight: FontWeight.w400)),
        ),
      ];
    } else {
      return [
        Text(text, style: TextStyle(color: textColor)),
      ];
    }
  }
}
