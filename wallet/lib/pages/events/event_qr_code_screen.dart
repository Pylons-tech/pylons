import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/gen/assets.gen.dart';
import 'package:pylons_wallet/generated/locale_keys.g.dart';
import 'package:pylons_wallet/model/event.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_image_asset.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';

const jsonExecuteRecipe = '''
      {
        "creator": "",
        "cookbook_id": "",
        "recipe_id": "",
        "eventName": "",
        "eventPrice": "",
        "eventCurrency": "",
        "coinInputsIndex": 0
        }
        ''';
final jsonMap = jsonDecode(jsonExecuteRecipe) as Map;

class EventQrCodeScreen extends StatefulWidget {
  const EventQrCodeScreen({
    super.key,
    required this.events,
  });

  final Events events;

  @override
  State<EventQrCodeScreen> createState() => _EventQrCodeScreenState();
}

class _EventQrCodeScreenState extends State<EventQrCodeScreen> {
  GlobalKey renderObjectKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.kBlack,
      child: Stack(
        children: [
          NftImageWidget(
            url: widget.events.thumbnail,
            opacity: 0.5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 23.w, top: MediaQuery.of(context).viewPadding.top + 13.h),
            child: GestureDetector(
              onTap: () async {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                Assets.images.icons.back,
                height: 25.h,
              ),
            ),
          ),
          ColoredBox(
            color: AppColors.kBlack.withOpacity(0.5),
            child: Align(
              child: RepaintBoundary(
                key: renderObjectKey,
                child: QrImageView(
                  padding: EdgeInsets.zero,
                  data: jsonEncode(widget.events),
                  size: 200,
                  dataModuleStyle: const QrDataModuleStyle(color: AppColors.kWhite),
                  eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.kWhite),
                ),
              ),
            ),
          ),
          Align(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SvgPicture.asset(Assets.images.svg.qrSideBorder),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: CustomPaintButton(
                title: LocaleKeys.done.tr(),
                bgColor: AppColors.kWhite.withOpacity(0.3),
                width: 280.w,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
