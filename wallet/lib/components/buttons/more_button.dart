import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/utils/constants.dart';

import '../../generated/locale_keys.g.dart';

class MoreButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool showText;

  const MoreButton({
    super.key,
    required this.onTap,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showText)
              Text(
                LocaleKeys.more.tr(),
                style: const TextStyle(fontWeight: FontWeight.w400),
              )
            else
              const SizedBox.shrink(),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: kIconSize,
              color: AppColors.kSelectedIcon,
            ),
          ],
        ));
  }
}
