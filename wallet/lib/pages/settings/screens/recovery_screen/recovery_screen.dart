import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/pages/settings/common/settings_divider.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/route_util.dart';

TextStyle kRecoveryOptionsText = TextStyle(fontSize: 18.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w500);
TextStyle kRecoveryHeadlineText = TextStyle(fontSize: 28.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w800);

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({Key? key}) : super(key: key);

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  bool shouldShowTestNetRecovery = false;

  Repository get repository => GetIt.I.get();

  ValueNotifier<String> mnemonicsNotifier =
      ValueNotifier('focus broom energy drift gravity plastic rigid busy iron collect metal squirrel ankle cousin cheap erupt media output merge couch window share ignore exclude');

  @override
  void initState() {
    super.initState();

    repository.logUserJourney(screenName: AnalyticsScreenEvents.recovery);

    final account = GetIt.I.get<WalletsStore>().getWallets().value.last;

    scheduleMicrotask(() {
      GetIt.I.get<Repository>().getMnemonic().then((value) {
        if (value.isRight()) {
          final mnemonicString = value.getOrElse(() => '');
          if (mnemonicString.isNotEmpty) {
            mnemonicsNotifier.value = mnemonicString;
            shouldShowTestNetRecovery = account.chainId == "pylons-testnet";
            setState(() {});
          }
        }
      });
    });
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
              "recovery".tr(),
              style: kRecoveryHeadlineText,
            ),
            SizedBox(
              height: 20.h,
            ),
            RecoveryForwardItem(
              title: "view_recovery_phrase".tr(),
              onPressed: () {
                Navigator.of(context).pushNamed(RouteUtil.ROUTE_VIEW_RECOVERY_PHRASE);
              },
            ),
            RecoveryForwardItem(
              title: "practice_test".tr(),
              onPressed: () {
                Navigator.of(context).pushNamed(RouteUtil.ROUTE_PRACTICE_TEST);
              },
            ),
            if (shouldShowTestNetRecovery)
              RecoveryForwardItem(
                title: "recovery_migration".tr(),
                onPressed: () async {
                  onRecoveryMigrationPressed();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future onRecoveryMigrationPressed() async {
    final diag = Loading()..showLoading();

    final walletStore = GetIt.I.get<WalletsStore>();

    final account = walletStore.getWallets().value.last;

    final name = account.name;

    final accountExists = await walletStore.isAccountExists(name);

    if (accountExists) {
      "account_already_exists".tr().show();
      diag.dismiss();
      return;
    }

    final response = await walletStore.importAlanWallet(mnemonicsNotifier.value, name);

    if (response.isLeft()) {
      response.swap().toOption().toNullable()?.message.show();
      diag.dismiss();
      return;
    }

    diag.dismiss();

    "account_migrated_successfully".tr().show();

    setState(() {
      shouldShowTestNetRecovery = false;
    });
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
