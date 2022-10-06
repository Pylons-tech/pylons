import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/pages/settings/common/settings_divider.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

TextStyle kRecoveryOptionsText = TextStyle(fontSize: 20.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w600);
TextStyle kViewRecoveryHeadlineText = TextStyle(fontSize: 28.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w800);

TextStyle kRecoveryBiometricIdText = TextStyle(fontSize: 20.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w500);
TextStyle kRecoveryInfoText = TextStyle(fontSize: 13.sp, fontFamily: kUniversalFontFamily, color: AppColors.kBlue, fontWeight: FontWeight.w500);
TextStyle kRecoveryMnemonicText = TextStyle(fontSize: 18.sp, fontFamily: kUniversalFontFamily, color: Colors.white, fontWeight: FontWeight.w800);
TextStyle kRecoveryMnemonicIndexText = TextStyle(fontSize: 10.sp, fontFamily: kUniversalFontFamily, color: Colors.white, fontWeight: FontWeight.w800);

class ViewRecoveryScreen extends StatefulWidget {
  const ViewRecoveryScreen({Key? key}) : super(key: key);

  @override
  State<ViewRecoveryScreen> createState() => _ViewRecoveryScreenState();
}

class _ViewRecoveryScreenState extends State<ViewRecoveryScreen> {
  ValueNotifier<List<String>> mnemonicsNotifier = ValueNotifier([]);

  bool shouldShowMnemonic = false;

  bool isBiometricAvailable = false;

  Repository get repository => GetIt.I.get();

  @override
  void initState() {
    super.initState();

    repository.getMnemonic().then((value) {
      if (value.isRight()) {
        final mnemonicString = value.getOrElse(() => '');
        mnemonicsNotifier.value = mnemonicString.split(" ");
      }
    });

    repository.isBiometricAvailable().then((value) {
      if (value.isLeft()) {
        shouldShowMnemonic = true;
      } else {
        isBiometricAvailable = true;
      }
      setState(() {});
    });

    repository.logUserJourney(screenName: AnalyticsScreenEvents.recoveryPhrase);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 37.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).viewPadding.top + 53.h),
              Align(
                alignment: Alignment.centerLeft,
                child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.kUserInputTextColor,
                    )),
              ),
              SizedBox(height: 33.h),
              Text(
                "recovery_phrase".tr(),
                style: kViewRecoveryHeadlineText,
              ),
              SizedBox(height: 20.h),
              if (isBiometricAvailable) ...[
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "biometric_id".tr(),
                        style: kRecoveryBiometricIdText,
                      ),
                      CupertinoSwitch(
                        trackColor: AppColors.kSwitchInactiveColor,
                        value: shouldShowMnemonic,
                        onChanged: (value) {
                          if (shouldShowMnemonic) {
                            return;
                          }

                          GetIt.I.get<Repository>().authenticate().then((value) {
                            if (value.isLeft()) {
                              value.swap().toOption().toNullable()!.message.show();
                            }

                            if (value.isRight() && value.getOrElse(() => false)) {
                              setState(() {
                                shouldShowMnemonic = true;
                              });
                            }
                          });
                        },
                        activeColor: AppColors.kSwitchActiveColor,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "biometric_reveal_phrase".tr(),
                  style: kRecoveryInfoText,
                ),
                SizedBox(height: 20.h),
                const SettingsDivider(),
              ],
              if (shouldShowMnemonic) ...[
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      "your_recovery_phrase".tr(),
                      style: kRecoveryOptionsText,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy,
                        color: AppColors.kCopyColor,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: mnemonicsNotifier.value.join(" "))).then((_) {
                          "copied_to_clipboard".tr().show();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                ValueListenableBuilder<List<String>>(
                    valueListenable: mnemonicsNotifier,
                    builder: (context, value, child) {
                      if (value.isEmpty) {
                        return const SizedBox();
                      }

                      return MnemonicList(
                        mnemonic: value,
                      );
                    }),
                SizedBox(height: 30.h),
                if (Platform.isAndroid)
                  InkWell(
                      onTap: () async {
                        onPressedUploadGoogleDrive();
                      },
                      child: buildBackupButton(title: "back_up_to_google_drive".tr())),
                if (Platform.isIOS)
                  InkWell(
                    onTap: () {
                      onPressedUploadICloudDrive();
                    },
                    child: buildBackupButton(title: "back_up_to_icloud".tr()),
                  ),
                SizedBox(height: 30.h),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteUtil.ROUTE_PRACTICE_TEST);
                  },
                  child: Text(
                    "practice_test".tr(),
                    style: kRecoveryInfoText.copyWith(fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 25.h),
              ]
            ],
          ),
        ),
      ),
    );
  }

  IgnorePointer buildBackupButton({required String title}) {
    return IgnorePointer(
      child: Container(
        alignment: Alignment.center,
        height: 45.h,
        width: 200.w,
        child: Stack(
          children: [
            SvgPicture.asset(
              SVGUtil.BUTTON_BACKGROUND,
              color: AppColors.kBlue,
            ),
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                    child: Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )))
          ],
        ),
      ),
    );
  }

  Future onPressedUploadGoogleDrive() async {
    final Loading loading = Loading();
    loading.showLoading();
    final wallets = GetIt.I.get<WalletsStore>().getWallets();
    final response = await GetIt.I.get<Repository>().uploadMnemonicGoogleDrive(mnemonic: mnemonicsNotifier.value.join(" "), username: wallets.value.last.name);

    loading.dismiss();
    if (response.isRight()) {
      "uploaded_successful".tr().show();
      return;
    } else {
      "upload_failed".tr().show();
    }
  }

  Future onPressedUploadICloudDrive() async {
    final Loading loading = Loading();
    loading.showLoading();
    final wallets = GetIt.I.get<WalletsStore>().getWallets();
    final response = await GetIt.I.get<Repository>().uploadMnemonicICloud(mnemonic: mnemonicsNotifier.value.join(" "), username: wallets.value.last.name);

    loading.dismiss();
    if (response.isRight()) {
      "uploaded_successful".tr().show();
      return;
    } else {
      "upload_failed".tr().show();
    }
  }
}

class RecoveryForwardItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const RecoveryForwardItem({required this.title, Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          SizedBox(
            height: 30.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: kRecoveryOptionsText,
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: AppColors.kForwardIconColor,
                )
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          const SettingsDivider()
        ],
      ),
    );
  }
}

class MnemonicClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 18);
    path.lineTo(18, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 18);
    path.lineTo(size.width - 18, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MnemonicList extends StatelessWidget {
  final List<String> mnemonic;

  const MnemonicList({Key? key, required this.mnemonic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildMnemonicRow(
          leftIndex: 1,
          rightIndex: 7,
          mnemonic: mnemonic,
          leftColor: colorList[0],
          rightColor: colorList[1],
        ),
        buildMnemonicRow(
          leftIndex: 2,
          rightIndex: 8,
          mnemonic: mnemonic,
          leftColor: colorList[2],
          rightColor: colorList[3],
        ),
        buildMnemonicRow(
          leftIndex: 3,
          rightIndex: 9,
          mnemonic: mnemonic,
          leftColor: colorList[4],
          rightColor: colorList[0],
        ),
        buildMnemonicRow(
          leftIndex: 4,
          rightIndex: 10,
          mnemonic: mnemonic,
          leftColor: colorList[1],
          rightColor: colorList[2],
        ),
        buildMnemonicRow(
          leftIndex: 5,
          rightIndex: 11,
          mnemonic: mnemonic,
          leftColor: colorList[3],
          rightColor: colorList[4],
        ),
        buildMnemonicRow(
          leftIndex: 6,
          rightIndex: 12,
          mnemonic: mnemonic,
          leftColor: colorList[0],
          rightColor: colorList[1],
        ),
      ],
    );
  }

  Widget buildMnemonicRow({required int leftIndex, required int rightIndex, required List<String> mnemonic, required Color leftColor, required Color rightColor}) {
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: buildMnemonicCard(mnemonic[leftIndex - 1], leftIndex, leftColor)),
          SizedBox(
            width: 10.w,
          ),
          Expanded(child: buildMnemonicCard(mnemonic[rightIndex - 1], rightIndex, rightColor)),
        ],
      ),
    );
  }

  Widget buildMnemonicCard(String name, int index, Color color) {
    return ClipPath(
      clipper: MnemonicClipper(),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: ColoredBox(
                color: color,
                child: Center(
                    child: Text(
                  name,
                  style: kRecoveryMnemonicText,
                  textAlign: TextAlign.center,
                ))),
          ),
          Positioned(
              left: 7.w,
              top: 5.h,
              child: Text(
                index.toString(),
                style: kRecoveryMnemonicIndexText,
              )),
        ],
      ),
    );
  }
}
