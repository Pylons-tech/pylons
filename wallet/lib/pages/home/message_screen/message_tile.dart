import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_wallet/model/notification_message.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/extension.dart';
import 'package:pylons_wallet/utils/svg_util.dart';
import 'package:pylons_wallet/utils/time_ago.dart' as time_ago;

class MessageTile extends StatefulWidget {
  const MessageTile({Key? key, required this.notificationMessage}) : super(key: key);

  final NotificationMessage notificationMessage;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    final TextStyle kMessageTextStyle = TextStyle(fontSize: 13.sp, fontFamily: kUniversalFontFamily, color: AppColors.kGray, fontWeight: FontWeight.w800);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.notificationMessage.read)
            const SizedBox()
          else
            SvgPicture.asset(
              SVGUtil.DOT,
            ),
          Row(
            children: [
              SvgPicture.asset(
                SVGUtil.PYLONS_LOGO,
                height: 22.h,
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: Text(
                  getMessageBasedOnType(widget.notificationMessage),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: kMessageTextStyle,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                getTimeFromInt(widget.notificationMessage.createdAt),
                style: kMessageTextStyle.copyWith(
                  fontSize: 10.sp,
                  color: AppColors.kLightGray,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          const Divider()
        ],
      ),
    );
  }

  String getMessageBasedOnType(NotificationMessage message) {
    switch (message.type) {
      case kSaleType:
        return "your_nft_sold_msg".tr(args: [message.itemName.trimStringShort(stringTrimConstantMin)]);
      default:
        return "";
    }
  }

  String getTimeFromInt(int createdAt) {
    final createdDate = DateTime.fromMillisecondsSinceEpoch(createdAt * kTimeStampInt);
    final Duration createdDuration = DateTime.now().difference(createdDate);
    final difference = DateTime.now().subtract(createdDuration);
    return time_ago.format(difference);
  }
}
