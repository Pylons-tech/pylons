import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/pages/settings/common/settings_divider.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/general_screen_localization_view_model.dart';
import 'package:pylons_wallet/pages/settings/screens/submit_feedback.dart';
import 'package:pylons_wallet/pages/settings/widgets/delete_dialog.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

TextStyle kHeadlineTextStyle = TextStyle(fontSize: 16.sp, fontFamily: kUniversalFontFamily, color: Colors.black);
TextStyle kSettingsOptionsTextStyle = TextStyle(fontSize: 20.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w500);
TextStyle kSettingsUserEnteredTextStyle = TextStyle(
  fontSize: 14.sp,
  fontFamily: kUniversalFontFamily,
  color: AppColors.kUserInputTextColor,
);
TextStyle kSettingsUserNameTextStyle = TextStyle(fontSize: 18.sp, fontFamily: kUniversalFontFamily, color: AppColors.kSettingsUserNameColor, fontWeight: FontWeight.w500);

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String name = '';
  String address = '';
  String description = '';

  TextEditingController emailController = TextEditingController();

  GeneralScreenLocalizationViewModel get _languageViewModel => GetIt.I.get();

  @override
  void initState() {
    super.initState();

    final currentWallet = GetIt.I.get<WalletsStore>().getWallets().value.last;
    name = currentWallet.name;
    address = currentWallet.publicAddress;

    getEmail();
    getDescription();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        body: SingleChildScrollView(
          child: ChangeNotifierProvider.value(
              value: _languageViewModel,
              builder: (context, child) {
                context.watch<GeneralScreenLocalizationViewModel>();
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 37.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).viewPadding.top + 20.h,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkResponse(
                            onTap: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.close)),
                      ),
                      SizedBox(
                          height: 100.h,
                          child: UserAvatarWidget(
                            radius: 40.h,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: kSettingsUserNameTextStyle,
                          )
                        ],
                      ),
                      Text(
                        "bio".tr(),
                        style: kHeadlineTextStyle,
                      ),
                      ClipPath(
                        clipper: PylonsLongRightBottomClipper(),
                        child: Container(
                          height: 90.h,
                          color: Colors.white,
                          padding: const EdgeInsets.only(top: 5),
                          child: TextFormField(
                            initialValue: description,
                            style: kSettingsUserEnteredTextStyle,
                            maxLength: 120,
                            maxLines: 4,
                            onChanged: (value) {
                              GetIt.I.get<Repository>().saveDescription(description: value);
                            },
                            decoration: InputDecoration(
                                hintText: "bio_text".tr(),
                                contentPadding: EdgeInsets.only(left: 10.w),
                                isDense: true,
                                isCollapsed: true,
                                filled: false,
                                counterText: '',
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                hintStyle: const TextStyle(fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "wallet_address".tr(),
                        style: kHeadlineTextStyle,
                      ),
                      ClipPath(
                        clipper: PylonsRightSmallBottomClipper(),
                        child: Container(
                            height: 30.h,
                            color: Colors.white,
                            padding: EdgeInsets.only(left: 10.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    address,
                                    style: kSettingsUserEnteredTextStyle,
                                    maxLines: 1,
                                  ),
                                ),
                                TextButton.icon(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
                                      backgroundColor: MaterialStateProperty.all(AppColors.kCopyColor),
                                    ),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: address)).then((_) {
                                        "wallet_copied".tr().show(context: context);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.copy,
                                      color: Colors.white,
                                    ),
                                    label: FittedBox(
                                      child: Text(
                                        "copy".tr(),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ))
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "email_address_optional".tr(),
                        style: kHeadlineTextStyle,
                      ),
                      ClipPath(
                        clipper: PylonsRightSmallBottomClipper(),
                        child: Container(
                          color: Colors.white,
                          height: 30.h,
                          child: TextFormField(
                            controller: emailController,
                            style: kSettingsUserEnteredTextStyle,
                            decoration: InputDecoration(
                                hintText: hintTextEmail,
                                hintStyle: TextStyle(
                                  color: AppColors.kUserInputTextColor,
                                ),
                                suffix: ColoredBox(
                                  color: AppColors.kCopyColor,
                                  child: TextButton.icon(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
                                        backgroundColor: MaterialStateProperty.all(AppColors.kCopyColor),
                                      ),
                                      onPressed: () async {
                                        if (emailController.text.isNotEmpty) {
                                          if (RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(emailController.text)) {
                                            GetIt.I.get<Repository>().saveEmail(value: emailController.text);
                                            "email_saved".tr().show(context: context);
                                            return;
                                          }

                                          "email_format_incorrect".tr().show(context: context);
                                          return;
                                        }
                                        "email_empty".tr().show(context: context);
                                      },
                                      icon: const Icon(
                                        Icons.save,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        "save".tr(),
                                        style: const TextStyle(color: Colors.white),
                                      )),
                                ),
                                contentPadding: EdgeInsets.only(left: 10.w),
                                isDense: true,
                                isCollapsed: true,
                                filled: false,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      buildLowerBottomOptions(),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Container buildLowerBottomOptions() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          SettingListItem(
            title: "general".tr(),
            imagePath: SVGUtil.SETTINGS_GENERAL,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.of(context).pushNamed(RouteUtil.ROUTE_GENERAL);
            },
          ),
          const SettingsDivider(),
          SettingListItem(
            title: "recovery".tr(),
            imagePath: SVGUtil.SETTINGS_RECOVERY,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.of(context).pushNamed(RouteUtil.ROUTE_RECOVERY);
            },
          ),
          const SettingsDivider(),
          SettingListItem(
            title: "legal".tr(),
            imagePath: SVGUtil.SETTINGS_LEGAL,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.of(context).pushNamed(RouteUtil.ROUTE_LEGAL);
            },
          ),
          const SettingsDivider(),
          SettingListItem(
            title: "submit_feedback".tr(),
            imagePath: SVGUtil.OWNER_REPORT,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              final SubmitFeedback submitFeedbackDialog = SubmitFeedback(context: context);
              submitFeedbackDialog.show();
            },
          ),
          const SettingsDivider(),
          SettingListItem(
            title: "delete_wallet".tr(),
            imagePath: SVGUtil.SETTINGS_DELETE,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              final DeleteDialog deleteDialog = DeleteDialog(context);
              deleteDialog.show();
            },
          ),
        ],
      ),
    );
  }

  void getEmail() {
    final emailEither = GetIt.I.get<Repository>().getSavedEmail();
    emailController.text = emailEither.getOrElse(() => '');
  }

  void getDescription() {
    final descriptionEither = GetIt.I.get<Repository>().getDescription();
    description = descriptionEither.getOrElse(() => '');
  }
}

class PylonsLongRightBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width - (size.width * 0.08), size.height)
      ..lineTo(size.width, size.height - (size.height * 0.2))
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class PylonsRightSmallBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width - (size.width * 0.06), size.height)
      ..lineTo(size.width, size.height - (size.height * 0.3))
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class SettingListItem extends StatefulWidget {
  final String title;
  final String imagePath;
  final VoidCallback onPressed;

  const SettingListItem({Key? key, required this.title, required this.imagePath, required this.onPressed}) : super(key: key);

  @override
  State<SettingListItem> createState() => _SettingListItemState();
}

class _SettingListItemState extends State<SettingListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Row(
          children: [
            SizedBox(
              height: 20.h,
              width: 20.h,
              child: SvgPicture.asset(
                widget.imagePath,
                color: AppColors.kBlack,
                height: 20.h,
                width: 20.h,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Text(
              widget.title,
              style: TextStyle(fontSize: 20.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
