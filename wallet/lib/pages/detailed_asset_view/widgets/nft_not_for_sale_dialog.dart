import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;

import '../../../generated/locale_keys.g.dart';
import '../../../main_prod.dart';
import '../../../utils/clipper_utils.dart';
import '../../../utils/constants.dart';
import '../../purchase_item/widgets/pay_with_swipe.dart';
import '../owner_view_view_model.dart';

class NFTNotForSaleDialog {
  final OwnerViewViewModel ownerViewViewModel;
  BuildContext buildContext;

  NFTNotForSaleDialog({
    required this.buildContext,
    required this.ownerViewViewModel,
  });

  void show() {
    showDialog(
      barrierDismissible: false,
      context: buildContext,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ChangeNotifierProvider<OwnerViewViewModel>.value(
            value: ownerViewViewModel,
            builder: (context, snapshot) {
              // return Text("abc");
              return NFTForSaleConfirmationWidget(
                ownerViewViewModel: ownerViewViewModel,
              );
            },
          ),
        );
      },
    );
  }
}

class NFTForSaleConfirmationWidget extends StatefulWidget {
  final OwnerViewViewModel ownerViewViewModel;

  const NFTForSaleConfirmationWidget({Key? key, required this.ownerViewViewModel}) : super(key: key);

  @override
  State<NFTForSaleConfirmationWidget> createState() => _NFTForSaleConfirmationWidgetState();
}

class _NFTForSaleConfirmationWidgetState extends State<NFTForSaleConfirmationWidget> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Container(
        key: const Key(kNotForSaleDialogKey),
        color: Colors.black.withOpacity(0.7),
        height: 250.h,
        width: isTablet ? 200.w : 270.w,
        margin: isTablet ? EdgeInsets.symmetric(horizontal: 30.w) : EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: SizedBox(
                height: 60.h,
                width: 80.w,
                child: ClipPath(
                  clipper: RightTriangleClipper(orientation: enums.Orientation.Orientation_SW),
                  child: Container(
                    color: AppColors.kDarkRed,
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: isTablet ? 2.w : 5.w, top: 5.h),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Text(
                      LocaleKeys.confirmation.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.kWhite, fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      LocaleKeys.delist_confirmation_msg.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.kWhite, fontSize: 15.sp, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: PylonsPayWithSwipe(
                        activeColor: AppColors.kDarkRed,
                        inactiveColor: AppColors.kPayNowBackgroundGrey,
                        height: 40.h,
                        initialWidth: 40.w,
                        onSwipeComplete: () {},
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
