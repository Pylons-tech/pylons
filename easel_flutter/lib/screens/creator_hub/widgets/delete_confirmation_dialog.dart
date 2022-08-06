import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/welcome_screen/widgets/common/dialog_clipper.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/dependency_injection/dependency_injection_container.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/widgets/clipped_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class DeleteDialog {
  final BuildContext contextt;
  final NFT nft;

  DeleteDialog({required this.contextt, required this.nft});

  CreatorHubViewModel get creatorHubViewModel => sl();

  Future<void> show() async {
    return showDialog(
        barrierColor: Colors.black38,
        barrierDismissible: false,
        context: contextt,
        builder: (_) {
          return Dialog(
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? 45.w : 15.w),
            backgroundColor: Colors.transparent,
            child: ClipPath(
              clipper: DialogClipper(),
              child: Container(
                color: EaselAppTheme.kLightRed,
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
                        kAlertIcon,
                        height: 40.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    Text(
                      "are_you_sure_you_want_to_delete",
                      textAlign: TextAlign.center,
                      style: EaselAppTheme.kDeleteHeaderTextStyle,
                    ).tr(),
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
                              title: "yes".tr(),
                              bgColor: EaselAppTheme.kPurple,
                              textColor: EaselAppTheme.kWhite,
                              fontWeight: FontWeight.w300,
                              clipperType: ClipperType.bottomLeftTopRight,
                              onPressed: () async {
                                Navigator.of(_).pop();
                                creatorHubViewModel.deleteNft(nft.id);
                              },
                              cuttingHeight: 12.h,
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Expanded(
                            child: ClippedButton(
                              title: "no".tr(),
                              bgColor: EaselAppTheme.kWhite.withOpacity(0.3),
                              textColor: EaselAppTheme.kWhite,
                              onPressed: ()  {
                                Navigator.of(_).pop();
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
