import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/buttons/pylons_get_started_button.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/generated/locale_keys.g.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_3d_asset.dart';
import 'package:pylons_wallet/pages/presenting_onboard_page/viewmodel/accept_policy_viewmodel.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AcceptPolicyScreen extends StatefulWidget {
  final NFT nft;
  final AcceptPolicyViewModel viewModel;

  const AcceptPolicyScreen({super.key, required this.nft, required this.viewModel});

  @override
  State<AcceptPolicyScreen> createState() => _AcceptPolicyScreenState();
}

class _AcceptPolicyScreenState extends State<AcceptPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: getTypeWidget(
                    widget.nft,
                  ),
                ),
                SizedBox(
                  height: 100.h,
                ),
              ],
            ),
          ),
          ChangeNotifierProvider.value(
            value: widget.viewModel,
            builder: (_, __) {
              return AcceptPolicyScreenContent(nft: widget.nft);
            },
          ),
        ],
      ),
    );
  }

  Widget getTypeWidget(NFT nft) {
    switch (nft.assetType) {
      case AssetType.Image:
        return imageWidget(nft.url);
      case AssetType.Audio:
      case AssetType.Video:
      case AssetType.Pdf:
        return imageWidget(nft.thumbnailUrl);
      case AssetType.ThreeD:
        return Container(
          color: AppColors.k3DBackgroundColor,
          height: double.infinity,
          child: Nft3dWidget(
            url: nft.url,
            cameraControls: false,
            backgroundColor: AppColors.kBlack,
            showLoader: true,
          ),
        );

      default:
        return imageWidget(nft.url);
    }
  }

  ColoredBox imageWidget(String url) {
    return ColoredBox(
      color: Colors.black,
      child: CachedNetworkImage(
        placeholder: (context, url) => Shimmer(color: PylonsAppTheme.cardBackground, child: const SizedBox.expand()),
        imageUrl: url,
        fit: BoxFit.contain,
      ),
    );
  }
}

class AcceptPolicyScreenContent extends StatelessWidget {
  final NFT nft;

  const AcceptPolicyScreenContent({
    super.key,
    required this.nft,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AcceptPolicyViewModel>();
    return Align(
      key: const Key(kAcceptPolicyPortionKey),
      alignment: Alignment.bottomCenter,
      child: ClipPath(
        clipper: TopCornerCut(depth: 30),
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
                onLinkTap: () {
                  /// TO DO
                  /// Don't have url of term & services
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
                onLinkTap: () => launchUrlString(kPrivacyPolicyLink),
              ),
              SizedBox(
                height: 25.0.h,
              ),
              PylonsGetStartedButton(
                key: const Key(kAcceptBottomSheetBtnKey),
                enabled: viewModel.isCheckTermServices && viewModel.isCheckPrivacyPolicy,
                onTap: () {
                  _onAcceptedTermsAndConditions(viewModel);
                },
                text: LocaleKeys.get_started.tr(),
                loader: ValueNotifier(false),
                fontWeight: FontWeight.normal,
                btnHeight: 40,
                btnWidth: 260,
                btnUnselectBGColor: AppColors.kDarkDividerColor,
                fontSize: 14,
                textColor: !(viewModel.isCheckTermServices && viewModel.isCheckPrivacyPolicy)
                    ? AppColors.kUserInputTextColor
                    : AppColors.kWhite,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onAcceptedTermsAndConditions(AcceptPolicyViewModel viewModel) async {
    final loading = Loading()..showLoading();

    final response = await viewModel.createAccountOnChain();
    loading.dismiss();

    if (response.isLeft()) {
      response.swap().toOption().toNullable()!.message.show();
      return;
    } else {
      viewModel.onTapGetStartedButton(nft);
    }
  }
}

class MyCheckBox extends StatelessWidget {
  final String policy;
  final bool isSelected;
  final ValueChanged<bool?>? onChange;
  final VoidCallback onLinkTap;

  const MyCheckBox(
    this.policy, {
    required this.isSelected,
    required this.onChange,
    required this.onLinkTap,
    super.key,
  });

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
                checkColor: AppColors.kBlack,
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
                  text: LocaleKeys.acknowledge_i_agree_to.tr(),
                  style: TextStyle(
                    color: AppColors.kBlack,
                    fontSize: 15.sp,
                  ),
                ),
                TextSpan(
                  text: policy,
                  style: TextStyle(
                    color: AppColors.kBlue,
                    fontSize: 15.sp,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onLinkTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
