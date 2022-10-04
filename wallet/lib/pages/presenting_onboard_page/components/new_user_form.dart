import 'package:cosmos_utils/mnemonic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_wallet/components/buttons/pylons_get_started_button.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/pylons_text_input_widget.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NewUserForm extends StatefulWidget {
  final WalletsStore walletsStore;

  const NewUserForm({Key? key, required this.walletsStore}) : super(key: key);

  @override
  NewUserFormState createState() => NewUserFormState();
}

class NewUserFormState extends State<NewUserForm> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();

  final isLoadingNotifier = ValueNotifier(false);

  bool _ackChecked1 = false;
  bool _ackChecked2 = false;
  final bool _ackChecked3 = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          VerticalSpace(90.h),
          SvgPicture.asset(
            SVGUtil.PYLONS_LOGO,
            width: 60.w,
            fit: BoxFit.fill,
          ),
          VerticalSpace(50.h),
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "pylon_username".tr(),
                style: TextStyle(
                  color: AppColors.kBlack,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ]),
          PylonsTextInput(controller: usernameController, label: "user_name".tr(), errorText: validateUsername),
          VerticalSpace(30.h),
          CheckboxListTile(
            value: _ackChecked1,
            title: Text('acknowledge_username_never_changed'.tr(),
                style: TextStyle(
                  color: AppColors.kBlack,
                  fontSize: 12.sp,
                )),
            onChanged: (value) {
              setState(() {
                _ackChecked1 = value!;
              });
            },
            selected: _ackChecked1,
            activeColor: AppColors.kPurple,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            value: _ackChecked2,
            title: RichText(
              text: TextSpan(
                style: TextStyle(color: AppColors.kBlack, fontSize: 12.sp),
                children: <TextSpan>[
                  TextSpan(
                      text: 'acknowledge_i_agree'.tr(),
                      style: TextStyle(
                        color: AppColors.kBlack,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      )),
                  TextSpan(
                      text: 'acknowledge_privacy_policy'.tr(),
                      style: TextStyle(
                        color: AppColors.kBlue,
                        fontSize: 12.sp,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrlString(kPrivacyPolicyLink);
                        }),
                ],
              ),
            ),
            onChanged: (value) {
              setState(() {
                _ackChecked2 = value!;
              });
            },
            selected: _ackChecked2,
            activeColor: AppColors.kPurple,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          VerticalSpace(210.h),
          Align(
            alignment: Alignment.bottomRight,
            child: PylonsGetStartedButton(
              key: ValueKey(_ackChecked3 && _ackChecked2 && _ackChecked2),
              enabled: _ackChecked3 && _ackChecked2 && _ackChecked2,
              onTap: onStartPylonsPressed,
              text: "get_started".tr(),
              loader: isLoadingNotifier,
            ),
          ),
        ],
      ),
    );
  }

  String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'user_name_empty'.tr();
    }

    return null;
  }

  Future<void> onStartPylonsPressed() async {
    if (_formKey.currentState!.validate()) {
      _registerNewUser(usernameController.value.text.trim());
    }
  }

  /// Create the new wallet and associate the chosen username with it.
  Future<void> _registerNewUser(String userName) async {
    isLoadingNotifier.value = true;
    final navigator = Navigator.of(context);

    final isAccountExists = await widget.walletsStore.isAccountExists(userName);

    if (isAccountExists) {
      isLoadingNotifier.value = false;
      "${'user_name_already_exists'.tr()}!".show();
      navigator.pop();
      return;
    }
    final mnemonic = await generateMnemonic(strength: kMnemonicStrength);
    final result = await widget.walletsStore.importAlanWallet(mnemonic, userName);

    isLoadingNotifier.value = false;
    result.fold((failure) {
      failure.message.show();
      navigator.pop();
    }, (walletInfo) async {
      Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamedAndRemoveUntil(RouteUtil.ROUTE_HOME, (route) => false);
    });
  }
}
