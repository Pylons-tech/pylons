import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/main.dart';
import 'package:evently/screens/custom_widgets/bottom_buttons.dart';
import 'package:evently/screens/event_hub/event_hub_view_model.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/di/di.dart';
import 'package:evently/utils/enums.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/route_util.dart';
import 'package:evently/utils/space_utils.dart';
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
        child: Consumer<EventlyProvider>(
          builder: (_, provider, __) => SafeArea(
            child: Scaffold(
              bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                decoration: BoxDecoration(color: EventlyAppTheme.kWhite, boxShadow: [
                  BoxShadow(
                      color: EventlyAppTheme.kGrey01.withOpacity(0.1),
                      // offset: Offset(0, 0),
                      // blurRadius: 20,
                      spreadRadius: 1)
                ]),
                height: 110.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BottomButtons(
                      onPressContinue: () {
                        onPublishPressed();
                      },
                      onPressSaveDraft: () {
                        final navigator = Navigator.of(context);
                        provider.saveAsDraft(
                          onCompleted: () => navigator.popUntil((route) => route.settings.name == RouteUtil.kRouteEventHub),
                          uploadStep: UploadStep.price,
                        );
                      },
                      isContinueEnable: true,
                      clipBtnTxt: LocaleKeys.publish.tr(),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Consumer<EventlyProvider>(
                  builder: (_, provider, __) => ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20.w, horizontal: 20.w),
                      child: Stack(
                        children: [
                          Image.asset(PngUtils.kHostPreview),
                          Column(
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
                                          provider.eventName,
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
                                          provider.startDate,
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
                                          provider.startTime,
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
                                            provider.location,
                                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: EventlyAppTheme.kWhite),
                                            maxLines: 2,
                                          ),
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
                                          'PERKS',
                                          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: EventlyAppTheme.kWhite),
                                        ),
                                        SizedBox(height: 1.h),
                                        Row(
                                          children: [
                                            SvgPicture.asset(SVGUtils.kDiamond),
                                            SizedBox(width: 5.w),
                                            Text(
                                              'x ${provider.perks.length}',
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
                              VerticalSpace(30.h),
                              Image.asset(PngUtils.kDottedLine),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
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

    final bool isRecipeCreated = await viewModel.createRecipe();
    pylonsLoadingAnimation.hide();
    if (!isRecipeCreated) {
      return;
    }

    sl<EventHubViewModel>().changeSelectedCollection(CollectionType.publish);
    navigator.popUntil((route) {
      return route.settings.name == RouteUtil.kRouteEventHub;
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
