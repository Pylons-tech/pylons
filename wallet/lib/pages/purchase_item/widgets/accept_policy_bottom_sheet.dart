import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/buttons/pylons_get_started_button.dart';
import 'package:pylons_wallet/generated/locale_keys.g.dart';
import 'package:pylons_wallet/pages/purchase_item/viewmodel/accept_policy_viewmodel.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/image_util.dart';

class AcceptPoliciesBottomSheet extends StatelessWidget {
  final VoidCallback onGetStarted;

  const AcceptPoliciesBottomSheet({Key? key, required this.onGetStarted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ChangeNotifierProvider.value(
          value: GetIt.I.get<AcceptPolicyViewModel>(),
          builder: (context, child) {
            return Consumer<AcceptPolicyViewModel>(
              builder: (context, viewModel, child) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: LeftRightTopClipper(),
                    child: Container(
                      height: 0.33.sh,
                      width: double.infinity,
                      color: AppColors.kMainBG,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60.h,
                            child: Image.asset(
                              ImageUtil.PYLONS_LOGO,
                            ),
                          ),
                          MyCheckBox(
                            LocaleKeys.acknowledge_terms_service.tr(),
                            isSelected: viewModel.isCheckTermServices,
                            onChange: (value) {
                              viewModel.toggleCheckTermServices(value!);
                            },
                          ),
                          SizedBox(
                            height: 15.0.h,
                          ),
                          MyCheckBox(
                            LocaleKeys.acknowledge_privacy_policy.tr(),
                            isSelected: viewModel.isCheckPrivacyPolicy,
                            onChange: (value) {
                              viewModel.toggleCheckPrivacyPolicy(value!);
                            },
                          ),
                          SizedBox(
                            height: 25.0.h,
                          ),
                          PylonsGetStartedButton(
                            key: const Key(kAcceptBottomSheetBtnKey),
                            enabled: viewModel.isCheckTermServices && viewModel.isCheckPrivacyPolicy,
                            onTap: onGetStarted,
                            text: LocaleKeys.get_started.tr(),
                            loader: ValueNotifier(false),
                            fontWeight: FontWeight.normal,
                            btnHeight: 40,
                            btnWidth: 260,
                            btnUnselectBGColor: AppColors.kDarkDividerColor,
                            fontSize: 14,
                            textColor: !(viewModel.isCheckTermServices && viewModel.isCheckPrivacyPolicy) ? AppColors.kUserInputTextColor : AppColors.kWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final String policy;
  final bool isSelected;
  final ValueChanged<bool?>? onChange;

  const MyCheckBox(
    this.policy, {
    required this.isSelected,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Checkbox.width,
          height: Checkbox.width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.kLightGrey,
            ),
            child: Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.transparent,
              ),
              child: Checkbox(
                value: isSelected,
                onChanged: onChange,
                activeColor: AppColors.kCheckboxActiveColor,
                checkColor: Colors.black,
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 15.0.w,
        ),
        SizedBox(
          width: 230.0.w,
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: AppColors.kBlack, fontSize: 12.sp),
              children: <TextSpan>[
                TextSpan(
                    text: LocaleKeys.acknowledge_i_agree.tr(),
                    style: TextStyle(
                      color: AppColors.kBlack,
                      fontSize: 15.sp,
                    )),
                TextSpan(
                  text: policy,
                  style: TextStyle(
                    color: AppColors.kBlue,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
