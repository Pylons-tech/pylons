import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/space_utils.dart';
import 'package:evently/widgets/clipped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    super.key,
    required this.onPressContinue,
    required this.onPressSaveDraft,
    required this.isContinueEnable,
    this.clipBtnTxt,
  });

  final VoidCallback onPressContinue;
  final VoidCallback onPressSaveDraft;
  final bool isContinueEnable;
  final String? clipBtnTxt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClippedButton(
          title: clipBtnTxt ?? LocaleKeys.continue_key.tr(),
          bgColor: isContinueEnable ? EventlyAppTheme.kBlue : EventlyAppTheme.kGery03,
          textColor: EventlyAppTheme.kWhite,
          onPressed: () {
            if (isContinueEnable) {
              onPressContinue();
            }
          },
          cuttingHeight: 15.h,
          clipperType: ClipperType.bottomLeftTopRight,
          isShadow: false,
          fontWeight: FontWeight.w700,
        ),
        const VerticalSpace(10),
        Center(
          child: InkWell(
            onTap: () {
              if (isContinueEnable) {
                onPressSaveDraft();
              }
            },
            child: Text(
              LocaleKeys.save_draft.tr(),
              style: TextStyle(color: EventlyAppTheme.kTextGrey02, fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const VerticalSpace(5),
      ],
    );
  }
}
