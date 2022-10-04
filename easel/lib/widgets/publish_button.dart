import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/widgets/clipped_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PublishButton extends StatelessWidget {
  final VoidCallback onPress;

  const PublishButton({Key? key, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClippedButton(
      key: const Key(kPublishButtonKey),
      title: "publish".tr(),
      bgColor: EaselAppTheme.kLightRed,
      textColor: EaselAppTheme.kWhite,
      onPressed: onPress,
      cuttingHeight: 15.h,
      clipperType: ClipperType.bottomLeftTopRight,
      isShadow: false,
      fontWeight: FontWeight.w700,
    );
  }
}
