import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/pages/settings/common/settings_divider.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

TextStyle kLegalOptionsText = TextStyle(
    fontSize: 18.sp,
    fontFamily: kUniversalFontFamily,
    color: Colors.black,
    fontWeight: FontWeight.w600);
TextStyle kLegalHeadlineText = TextStyle(
    fontSize: 28.sp,
    fontFamily: kUniversalFontFamily,
    color: Colors.black,
    fontWeight: FontWeight.w800);

class LegalScreen extends StatefulWidget {
  const LegalScreen({Key? key}) : super(key: key);

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 37.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top + 20.h,
            ),

            SizedBox(
              height: 33.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: kUserInputTextColor,
                  )),
            ),
            SizedBox(
              height: 33.h,
            ),
            Text(
              "legal",
              style: kLegalHeadlineText,
            ).tr(),
            SizedBox(
              height: 20.h,
            ),
            // LegalForwardItem(
            //   title: kTermsOfServiceText,
            //   onPressed: () {},
            // ),
            LegalForwardItem(
              title: "privacy_policy",
              onPressed: () {
                launchUrlString(kPrivacyPolicyLink);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LegalForwardItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const LegalForwardItem(
      {required this.title, Key? key, required this.onPressed})
      : super(key: key);

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
                  title.tr(),
                  style: kLegalOptionsText,
                ),
                const Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: kForwardIconColor,
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
