import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/pages/settings/common/settings_divider.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';

TextStyle kSecurityLabelText = TextStyle(fontSize: 28.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w800);
TextStyle kSecurityBiometricIdText = TextStyle(fontSize: 17.sp, color: Colors.black, fontWeight: FontWeight.w500);
TextStyle kSecurityNoBiometricText = TextStyle(fontSize: 15.sp, color: AppColors.kDarkRed, fontWeight: FontWeight.w500);

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool isBiometricAvailable = false;
  BiometricType biometricType = BiometricType.fingerprint;

  bool mainBiometricAvailable = false;
  bool loginBiometricAvailable = false;
  bool transactionBiometricAvailable = false;

  Repository get repository => GetIt.I.get();

  @override
  void initState() {
    super.initState();
    repository.logUserJourney(screenName: AnalyticsScreenEvents.security);

    getBiometricData();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPadding = EdgeInsets.symmetric(horizontal: 37.w);

    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top + 20.h,
          ),
          SizedBox(
            height: 33.h,
          ),
          Container(
            padding: defaultPadding,
            child: Align(
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
          ),
          SizedBox(
            height: 33.h,
          ),
          Container(
            padding: defaultPadding,
            child: Text(
              "security".tr(),
              style: kSecurityLabelText,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          if (isBiometricAvailable) ...[
            Container(
              padding: defaultPadding,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "biometric_id".tr(),
                      style: kSecurityBiometricIdText,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CupertinoSwitch(
                    trackColor: AppColors.kSwitchInactiveColor,
                    value: mainBiometricAvailable,
                    onChanged: (allowBiometric) {
                      onMainBiometricEnabled(allowBiometric: allowBiometric);
                    },
                    activeColor: AppColors.kSwitchActiveColor,
                  )
                ],
              ),
            ),
            Container(
              height: 4,
              color: AppColors.kDarkDividerColor,
            ),
            SizedBox(
              height: 20.h,
            ),
            if (mainBiometricAvailable) ...[Container(padding: defaultPadding, child: buildLogin()), Container(padding: defaultPadding, child: buildTransactions())]
          ],
          if (!isBiometricAvailable)
            Container(
              padding: defaultPadding,
              child: Text(
                "no_biometric".tr(),
                style: kSecurityNoBiometricText,
              ),
            )
        ],
      ),
    );
  }

  void onMainBiometricEnabled({required bool allowBiometric}) {
    final repository = GetIt.I.get<Repository>();
    if (allowBiometric) {
      repository.authenticate().then((value) {
        if (value.isLeft()) {
          value.swap().toOption().toNullable()!.message.show();
        }

        if (value.isRight() && value.getOrElse(() => false)) {
          setState(() {
            mainBiometricAvailable = value.isRight() && value.getOrElse(() => false);
          });
          repository.saveDefaultSecurityBiometric(biometricEnabled: mainBiometricAvailable);
        }
      });
    } else {
      repository.saveDefaultSecurityBiometric(biometricEnabled: false);
      repository.saveBiometricLogin(biometricEnabled: false);
      repository.saveBiometricTransaction(biometricEnabled: false);

      setState(() {
        mainBiometricAvailable = false;
        loginBiometricAvailable = false;
        transactionBiometricAvailable = false;
      });
    }
  }

  Widget buildLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 20.h,
        ),
        Text(
          "login".tr(),
          style: kSecurityLabelText.copyWith(fontSize: 22.sp),
        ),
        SizedBox(
          height: 25.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              biometricType == BiometricType.fingerprint ? "fingerprint".tr() : "face_id".tr(),
              style: kSecurityBiometricIdText,
            ),
            CupertinoSwitch(
              trackColor: AppColors.kSwitchInactiveColor,
              value: loginBiometricAvailable,
              onChanged: (allowLogin) {
                processLoginBiometric(allowLogin: allowLogin);
              },
              activeColor: AppColors.kSwitchActiveColor,
            )
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        const SettingsDivider()
      ],
    );
  }

  void processLoginBiometric({required bool allowLogin}) {
    final repository = GetIt.I.get<Repository>();
    if (allowLogin) {
      repository.authenticate().then((value) {
        if (value.isLeft()) {
          value.swap().toOption().toNullable()!.message.show();
        }

        if (value.isRight() && value.getOrElse(() => false)) {
          setState(() {
            loginBiometricAvailable = value.isRight() && value.getOrElse(() => false);
          });
          repository.saveBiometricLogin(biometricEnabled: loginBiometricAvailable);
        }
      });
    } else {
      repository.saveBiometricLogin(biometricEnabled: false);

      setState(() {
        loginBiometricAvailable = false;
      });
    }
  }

  Widget buildTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 20.h,
        ),
        Text(
          "transactions".tr(),
          style: kSecurityLabelText.copyWith(fontSize: 22.sp),
        ),
        SizedBox(
          height: 25.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              biometricType == BiometricType.fingerprint ? "fingerprint".tr() : "face_id".tr(),
              style: kSecurityBiometricIdText,
            ),
            CupertinoSwitch(
              trackColor: AppColors.kSwitchInactiveColor,
              value: transactionBiometricAvailable,
              onChanged: (allowTransaction) {
                processTransactionBiometric(allowTransaction: allowTransaction);
              },
              activeColor: AppColors.kSwitchActiveColor,
            )
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        const SettingsDivider()
      ],
    );
  }

  void processTransactionBiometric({required bool allowTransaction}) {
    final repository = GetIt.I.get<Repository>();

    if (allowTransaction) {
      repository.authenticate().then((value) {
        if (value.isLeft()) {
          value.swap().toOption().toNullable()!.message.show();
        }

        if (value.isRight() && value.getOrElse(() => false)) {
          setState(() {
            transactionBiometricAvailable = value.isRight() && value.getOrElse(() => false);
          });
          repository.saveBiometricTransaction(biometricEnabled: transactionBiometricAvailable);
        }
      });
    } else {
      repository.saveBiometricTransaction(biometricEnabled: false);
      setState(() {
        transactionBiometricAvailable = false;
      });
    }
  }

  Future getBiometricData() async {
    final repository = GetIt.I.get<Repository>();

    final biometricAvailableResponse = await repository.isBiometricAvailable();

    if (biometricAvailableResponse.isLeft()) {
      return;
    }
    isBiometricAvailable = true;
    biometricType = biometricAvailableResponse.getOrElse(() => BiometricType.fingerprint);

    final securityBiometricResponse = repository.getSecurityBiometric();

    if (securityBiometricResponse.isLeft()) {
      setState(() {});
      return;
    }

    mainBiometricAvailable = securityBiometricResponse.getOrElse(() => false);

    final loginBiometricResponse = repository.getBiometricLogin();

    if (loginBiometricResponse.isLeft()) {
      setState(() {});
      return;
    }

    loginBiometricAvailable = loginBiometricResponse.getOrElse(() => false);

    final transactionBiometricResponse = repository.getBiometricTransaction();

    if (transactionBiometricResponse.isLeft()) {
      setState(() {});
      return;
    }

    transactionBiometricAvailable = transactionBiometricResponse.getOrElse(() => false);

    setState(() {});
  }
}
