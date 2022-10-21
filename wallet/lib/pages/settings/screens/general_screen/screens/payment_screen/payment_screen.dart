import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/pages/settings/common/settings_divider.dart';
import 'package:pylons_wallet/pages/stripe_screen.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/stripe_handler.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/route_util.dart';

TextStyle kPaymentLabelText = TextStyle(fontSize: 28.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w800);
TextStyle kPaymentOptionsText = TextStyle(fontSize: 18.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w500);

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Repository get repository => GetIt.I.get();

  @override
  void initState() {
    super.initState();

    repository.logUserJourney(screenName: AnalyticsScreenEvents.payment);
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
                  )),
            ),
            SizedBox(
              height: 33.h,
            ),
            Text(
              "payment".tr(),
              style: kPaymentLabelText,
            ),
            SizedBox(
              height: 20.h,
            ),
            PaymentForwardItem(
              title: "connect_stripe_to_get_paid".tr(),
              onPressed: () {
                handleStripeAccountLink();
              },
            ),
            PaymentForwardItem(
              title: "transaction_history".tr(),
              onPressed: () {
                Navigator.of(context).pushNamed(RouteUtil.ROUTE_TRANSACTION_HISTORY);
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> handleStripeAccountLink() async {
    final loading = Loading()..showLoading();

    final account_response = await GetIt.I.get<StripeHandler>().handleStripeAccountLink();
    loading.dismiss();
    account_response.fold((fail) => {fail.message.show()}, (accountlink) {
      showDialog(
          useSafeArea: false,
          context: context,
          builder: (BuildContext context) {
            return StripeScreen(
                url: accountlink,
                onBack: () {
                  navigatorKey.currentState!.pop();
                });
          });
    });
  }
}

class PaymentForwardItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const PaymentForwardItem({required this.title, Key? key, required this.onPressed}) : super(key: key);

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
                Expanded(
                  child: Text(
                    title,
                    style: kPaymentOptionsText,
                    overflow: TextOverflow.ellipsis,
                  ),
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
