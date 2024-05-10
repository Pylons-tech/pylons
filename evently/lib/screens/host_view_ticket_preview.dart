import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/main.dart';
import 'package:evently/screens/custom_widgets/bottom_buttons.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/route_util.dart';
import 'package:evently/utils/space_utils.dart';
import 'package:evently/widgets/pylon_loading_animation.dart';
import 'package:evently/widgets/show_wallet_install_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

class HostTicketPreview extends StatefulWidget {
  const HostTicketPreview({super.key});

  @override
  State<HostTicketPreview> createState() => _HostTicketPreviewState();
}

class _HostTicketPreviewState extends State<HostTicketPreview> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EventlyAppTheme.kWhite,
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            height: 110.h,
            child: BottomButtons(
              onPressContinue: () {},
              onPressSaveDraft: () {},
              isContinueEnable: false,
            ),
          ),
          body: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20.w, horizontal: 20.w),
                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage(PngUtils.kHostPreview), fit: BoxFit.fitHeight),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(14),
                          topLeft: Radius.circular(14),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Image.asset(
                              PngUtils.kPhantom,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.h, left: 10.w),
                              child: Text(
                                'The Phantom of the Opera',
                                style: TextStyle(fontSize: 20.sp, color: EventlyAppTheme.kWhite, fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    VerticalSpace(10.h),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 30.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'DATE',
                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: EventlyAppTheme.kWhite),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Jul 04, 2022',
                                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: EventlyAppTheme.kWhite),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Time',
                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: EventlyAppTheme.kWhite),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                '7:15 PM',
                                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: EventlyAppTheme.kWhite),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    VerticalSpace(20.h),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 30.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'LOCATION',
                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: EventlyAppTheme.kWhite),
                              ),
                              SizedBox(height: 1.h),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 1.sw / 2.4),
                                child: Text(
                                  '245 W 44th St New York, NY 10036',
                                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: EventlyAppTheme.kWhite),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'SEAT',
                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: EventlyAppTheme.kWhite),
                              ),
                              SizedBox(height: 1.h),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '6A',
                                    style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold, color: EventlyAppTheme.kWhite),
                                  ),
                                  Text(
                                    'Room 3',
                                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: EventlyAppTheme.kWhite),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 30.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'PERKS',
                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: EventlyAppTheme.kWhite),
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  SvgPicture.asset(SVGUtils.kDiamond),
                                  SizedBox(width: 5.w),
                                  Text(
                                    'x 3',
                                    style: TextStyle(fontSize: 15.sp, color: EventlyAppTheme.kWhite, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    'Redeem',
                                    style: TextStyle(fontSize: 15.sp, color: EventlyAppTheme.kGreenText, fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    VerticalSpace(16.h),
                    Image.asset(PngUtils.kDottedLine),
                    VerticalSpace(40.h),
                    Text(
                      'Scan QR to enter',
                      style: TextStyle(
                        color: EventlyAppTheme.kWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                    VerticalSpace(10.h),
                    Container(
                      decoration: const BoxDecoration(color: EventlyAppTheme.kBlack),
                      width: 338,
                      height: 338,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onPublishPressed() async {
    final viewModel = context.read<EventlyProvider>();
    final navigator = Navigator.of(context);

    final PylonsLoadingAnimation pylonsLoadingAnimation = PylonsLoadingAnimation(context: context);
    pylonsLoadingAnimation.show();

    final isPylonsWalletExists = await PylonsWallet.instance.exists();

    if (!isPylonsWalletExists) {
      pylonsLoadingAnimation.hide();
      _showInstallWalletDialog();
      return;
    }

    final profileResponse = await viewModel.getProfile();

    if (profileResponse.errorCode == kErrProfileNotExist) {
      pylonsLoadingAnimation.hide();
      _showCreateAccountDialog();
      return;
    }

    if (viewModel.showStripeDialog()) {
      pylonsLoadingAnimation.hide();
      _showStripeDialog();
      return;
    }

    final bool isRecipeCreated = await viewModel.createRecipe(event: viewModel.event);
    pylonsLoadingAnimation.hide();
    if (!isRecipeCreated) {
      return;
    }

    navigator.popUntil((route) {
      return route.settings.name == RouteUtil.kCreateEvent;
    });
  }

  void _showInstallWalletDialog() {
    final ShowWalletInstallDialog showWalletInstallDialog = ShowWalletInstallDialog(
      context: context,
      errorMessage: LocaleKeys.download_pylons_description.tr(),
      buttonMessage: LocaleKeys.download_pylons_app.tr(),
      onButtonPressed: () {
        PylonsWallet.instance.goToInstall();
      },
      onClose: () {
        Navigator.of(navigatorKey.currentState!.overlay!.context).pop();
      },
    );

    showWalletInstallDialog.show();
  }

  void _showCreateAccountDialog() {
    final ShowWalletInstallDialog showWalletInstallDialog = ShowWalletInstallDialog(
      context: context,
      errorMessage: LocaleKeys.create_username_description.tr(),
      buttonMessage: LocaleKeys.open_pylons_app.tr(),
      onButtonPressed: () {
        PylonsWallet.instance.goToPylons();
      },
      onClose: () {
        Navigator.of(navigatorKey.currentState!.overlay!.context).pop();
      },
    );
    showWalletInstallDialog.show();
  }

  void _showStripeDialog() {
    final ShowWalletInstallDialog showWalletInstallDialog = ShowWalletInstallDialog(
      context: context,
      errorMessage: LocaleKeys.create_stripe_description.tr(),
      buttonMessage: LocaleKeys.start.tr(),
      onButtonPressed: () async {
        Navigator.pop(navigatorKey.currentState!.overlay!.context);
        await PylonsWallet.instance.showStripe();
      },
      onClose: () {
        Navigator.of(navigatorKey.currentState!.overlay!.context).pop();
      },
    );
    showWalletInstallDialog.show();
  }
}
