import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/pages/settings/common/settings_divider.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../services/repository/repository.dart';

TextStyle kLegalOptionsText = TextStyle(fontSize: 18.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w500);
TextStyle kLegalHeadlineText = TextStyle(fontSize: 28.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w800);

class LegalScreen extends StatefulWidget {
  const LegalScreen({Key? key}) : super(key: key);

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  Repository get repository => GetIt.I.get();

  @override
  void initState() {
    super.initState();
    repository.logUserJourney(screenName: AnalyticsScreenEvents.legal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
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
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.kUserInputTextColor,
                ),
              ),
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

  const LegalForwardItem({required this.title, Key? key, required this.onPressed}) : super(key: key);

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
