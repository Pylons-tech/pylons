import 'package:easy_localization/easy_localization.dart';
import 'package:evently/main.dart';
import 'package:evently/models/events.dart';
import 'package:evently/screens/event_hub/event_hub_view_model.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/di/di.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/widgets/clipped_button.dart';
import 'package:evently/widgets/dialog_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../generated/locale_keys.g.dart';

class DeleteDialog {
  final BuildContext contextt;
  final Events events;

  DeleteDialog({required this.contextt, required this.events});

  EventHubViewModel get creatorHubViewModel => sl();

  Future<void> show() async {
    return showDialog(
        barrierColor: Colors.black38,
        barrierDismissible: false,
        context: contextt,
        builder: (context) {
          return Dialog(
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? 45.w : 15.w),
            backgroundColor: EventlyAppTheme.kTransparent,
            child: ClipPath(
              clipper: DialogClipper(),
              child: Container(
                color: EventlyAppTheme.kLightRed,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Align(
                      child: SvgPicture.asset(
                        SVGUtils.kAlertIcon,
                        height: 40.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    Text(
                      LocaleKeys.are_you_sure_you_want_to_delete.tr(),
                      textAlign: TextAlign.center,
                      style: EventlyAppTheme.kDeleteHeaderTextStyle,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      height: 40.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClippedButton(
                              title: LocaleKeys.yes.tr(),
                              bgColor: EventlyAppTheme.kTextDarkPurple,
                              textColor: EventlyAppTheme.kWhite,
                              fontWeight: FontWeight.w300,
                              clipperType: ClipperType.bottomLeftTopRight,
                              onPressed: () async {
                                Navigator.of(context).pop();
                                creatorHubViewModel.deleteEvents(events.id);
                              },
                              cuttingHeight: 12.h,
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Expanded(
                            child: ClippedButton(
                              title: LocaleKeys.no.tr(),
                              bgColor: EventlyAppTheme.kWhite.withOpacity(0.3),
                              textColor: EventlyAppTheme.kWhite,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              cuttingHeight: 12.h,
                              fontWeight: FontWeight.w300,
                              clipperType: ClipperType.bottomLeftTopRight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
