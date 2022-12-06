import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/custom_widgets/step_labels.dart';
import 'package:easel_flutter/screens/custom_widgets/steps_indicator.dart';
import 'package:easel_flutter/utils/amount_formatter.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/viewmodels/home_viewmodel.dart';
import 'package:easel_flutter/widgets/clipped_button.dart';
import 'package:easel_flutter/widgets/easel_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';
import '../models/denom.dart';
import '../utils/dollar_sign_amount_formatter.dart';
import '../utils/percentage_sign_formatter.dart';
import '../widgets/easel_price_input_field.dart';
import 'clippers/bottom_left_curved_corner_clipper.dart';
import 'clippers/small_bottom_corner_clipper.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final _formKey = GlobalKey<FormState>();
  Repository repository = GetIt.I.get<Repository>();
  NFT? nft;

  final ValueNotifier<String> _royaltiesFieldError = ValueNotifier("");
  final ValueNotifier<String> _noOfEditionsFieldError = ValueNotifier("");
  final ValueNotifier<String> _priceFieldError = ValueNotifier("");

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nft = repository.getCacheDynamicType(key: nftKey) as NFT;
    repository.logUserJourney(screenName: AnalyticsScreenEvents.priceScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    final easelProvider = context.read<EaselProvider>();
    return Scaffold(
      body: GestureDetector(
        onTap: easelProvider.onOutsideTouch,
        child: SingleChildScrollView(
          child: Consumer<EaselProvider>(builder: (_, provider, __) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ValueListenableBuilder(
                          valueListenable: homeViewModel.currentPage,
                          builder: (_, int currentPage, __) => Padding(
                            padding: EdgeInsets.only(left: 10.sp),
                            child: IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                homeViewModel.previousPage();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: EaselAppTheme.kGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const VerticalSpace(20),
                          MyStepsIndicator(currentStep: homeViewModel.currentStep),
                          const VerticalSpace(5),
                          StepLabels(currentPage: homeViewModel.currentPage, currentStep: homeViewModel.currentStep),
                          const VerticalSpace(10),
                        ],
                      ),
                    ],
                  ),
                  ScreenResponsive(
                    mobileScreen: (context) => const VerticalSpace(6),
                    tabletScreen: (context) => const VerticalSpace(30),
                  ),
                  VerticalSpace(10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.is_this_free.tr(),
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  provider.updateIsFreeDropStatus(FreeDrop.yes);
                                },
                                child: Container(
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    color: provider.isFreeDrop == FreeDrop.yes
                                        ? EaselAppTheme.kBlue
                                        : EaselAppTheme.kTransparent,
                                    border: Border.all(
                                      color: provider.isFreeDrop == FreeDrop.yes
                                          ? EaselAppTheme.kBlue
                                          : EaselAppTheme.kBlack,
                                      width: 2.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.yes.tr(),
                                      style: TextStyle(
                                        color: provider.isFreeDrop == FreeDrop.yes
                                            ? EaselAppTheme.kWhite
                                            : EaselAppTheme.kBlack,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  provider.updateIsFreeDropStatus(FreeDrop.no);
                                },
                                child: Container(
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    color: provider.isFreeDrop == FreeDrop.no
                                        ? EaselAppTheme.kBlue
                                        : EaselAppTheme.kTransparent,
                                    border: Border.all(
                                      color: provider.isFreeDrop == FreeDrop.no
                                          ? EaselAppTheme.kBlue
                                          : EaselAppTheme.kBlack,
                                      width: 2.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.no.tr(),
                                      style: TextStyle(
                                        color: provider.isFreeDrop == FreeDrop.no
                                            ? EaselAppTheme.kWhite
                                            : EaselAppTheme.kBlack,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (provider.isFreeDrop == FreeDrop.no)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30.h,
                              ),
                              Text(
                                LocaleKeys.payment_type.tr(),
                                style: TextStyle(
                                  color: EaselAppTheme.kDarkPurple,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: EaselAppTheme.kBlue, width: 3),
                                ),
                                margin: EdgeInsets.only(top: 5.h),
                                padding: const EdgeInsets.all(3),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ClipPath(
                                        clipper: RightSmallBottomClipper(cuttingEdgeValue: 15),
                                        child: GestureDetector(
                                          onTap: () {
                                            easelProvider.setSelectedDenom(
                                              Denom(
                                                name: kPylonText,
                                                symbol: kPylonSymbol,
                                                icon: PngUtils.kIconDenomPylon,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: easelProvider.selectedDenom.name == kPylonText
                                                  ? EaselAppTheme.kBlue
                                                  : EaselAppTheme.kTransparent,
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                                            child: Text(
                                              LocaleKeys.apple_or_google_play.tr(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: easelProvider.selectedDenom.name == kPylonText
                                                    ? EaselAppTheme.kWhite
                                                    : EaselAppTheme.kGrey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    Expanded(
                                      child: ClipPath(
                                        clipper: BottomLeftCurvedCornerClipper(cuttingEdge: 15),
                                        child: GestureDetector(
                                          onTap: () {
                                            easelProvider.setSelectedDenom(
                                              Denom(
                                                name: kUSDText,
                                                symbol: kUsdSymbol,
                                                icon: PngUtils.kIconDenomUsd,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: easelProvider.selectedDenom.name == kUSDText
                                                  ? EaselAppTheme.kBlue
                                                  : EaselAppTheme.kTransparent,
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                                            child: Text(
                                              LocaleKeys.credit_or_debit_card.tr(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: easelProvider.selectedDenom.name == kUSDText
                                                    ? EaselAppTheme.kWhite
                                                    : EaselAppTheme.kGrey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if (provider.isFreeDrop != FreeDrop.unselected)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (provider.isFreeDrop == FreeDrop.no)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VerticalSpace(20.h),
                                    EaselPriceInputField(
                                      key: ValueKey("${provider.selectedDenom.name}-amount"),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(kMaxPriceLength),
                                        DollarSignAmountFormatter(),
                                      ],
                                      controller: provider.priceController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          _priceFieldError.value = LocaleKeys.enter_price.tr();
                                          return;
                                        }
                                        if (double.parse(value.replaceAll(",", "").replaceAll("\$", "")) < kMinValue) {
                                          _priceFieldError.value = "${LocaleKeys.minimum_is.tr()} $kMinValue";
                                          return;
                                        }
                                        _priceFieldError.value = '';
                                        return null;
                                      },
                                    ),
                                    ValueListenableBuilder<String>(
                                        valueListenable: _priceFieldError,
                                        builder: (_, String priceFieldError, __) {
                                          if (priceFieldError.isEmpty) {
                                            return const SizedBox.shrink();
                                          }
                                          return Padding(
                                            padding: EdgeInsets.only(left: 8.w, right: 10.w, top: 2.h),
                                            child: Text(
                                              priceFieldError,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.red,
                                              ),
                                            ),
                                          );
                                        }),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: LocaleKeys.network_fee_required.tr(),
                                            style: TextStyle(
                                              color: EaselAppTheme.kLightPurple,
                                              fontSize: 12.sp,
                                              fontFamily: kUniversalFontFamily,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " ${LocaleKeys.learn_more.tr()}",
                                            style: TextStyle(
                                              color: EaselAppTheme.kBlue,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()..onTap = easelProvider.onLearnMoreClick,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              VerticalSpace(20.h),
                              EaselTextField(
                                key: ValueKey(provider.selectedDenom.name),
                                label: LocaleKeys.no_of_editions.tr(),
                                hint: LocaleKeys.editions_are_sold_sequentially.tr(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(5),
                                  AmountFormatter(
                                    maxDigits: 5,
                                  )
                                ],
                                controller: provider.noOfEditionController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    _noOfEditionsFieldError.value = LocaleKeys.enter_number_editions.tr();
                                    return;
                                  }
                                  if (int.parse(value.replaceAll(",", "")) < kMinEditionValue) {
                                    _noOfEditionsFieldError.value = "${LocaleKeys.minimum_is.tr()} $kMinEditionValue";
                                    return;
                                  }
                                  if (int.parse(value.replaceAll(",", "")) > kMaxEdition) {
                                    _noOfEditionsFieldError.value = "${LocaleKeys.maximum_is.tr()} $kMaxEdition";
                                    return;
                                  }
                                  _noOfEditionsFieldError.value = '';
                                  return null;
                                },
                              ),
                              ValueListenableBuilder<String>(
                                valueListenable: _noOfEditionsFieldError,
                                builder: (_, String noOfEditionsFieldError, __) {
                                  if (noOfEditionsFieldError.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                                    child: Text(
                                      noOfEditionsFieldError,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              VerticalSpace(3.h),
                              Container(
                                padding: EdgeInsets.only(right: 15.w),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${NumberFormat.decimalPattern().format(kMaxEdition)} ${LocaleKeys.maximum.tr()}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: EaselAppTheme.kLightPurple,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              VerticalSpace(10.h),
                              EaselTextField(
                                label: LocaleKeys.royalties.tr(),
                                hint: LocaleKeys.min_of_1_per.tr(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                  PercentageSignFormatter()
                                ],
                                controller: provider.royaltyController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    _royaltiesFieldError.value = LocaleKeys.enter_royalty_in_percentage.tr();
                                    return;
                                  }
                                  if (int.parse(value.replaceAll("%", "")) > kMaxRoyalty) {
                                    _royaltiesFieldError.value =
                                        "${LocaleKeys.allowed_royalty_is_between.tr()} $kMinRoyalty-$kMaxRoyalty %";
                                    return;
                                  }
                                  _royaltiesFieldError.value = '';
                                  return null;
                                },
                              ),
                              ValueListenableBuilder<String>(
                                valueListenable: _royaltiesFieldError,
                                builder: (_, String royaltiesFieldError, __) {
                                  if (royaltiesFieldError.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                                    child: Text(
                                      royaltiesFieldError,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              VerticalSpace(3.h),
                              Text(
                                LocaleKeys.royalty_note.tr(),
                                style: TextStyle(
                                  color: EaselAppTheme.kLightPurple,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        if (provider.isFreeDrop == FreeDrop.unselected)
                          ScreenResponsive(
                            mobileScreen: (_) => VerticalSpace(0.42.sh),
                            tabletScreen: (_) => VerticalSpace(0.28.sh),
                          ),
                        if (provider.isFreeDrop == FreeDrop.yes)
                          ScreenResponsive(
                            mobileScreen: (_) => VerticalSpace(0.2.sh),
                            tabletScreen: (_) => VerticalSpace(0.05.sh),
                          ),
                        VerticalSpace(20.h),
                        ClippedButton(
                          title: LocaleKeys.continue_key.tr(),
                          bgColor: provider.isFreeDrop != FreeDrop.unselected
                              ? EaselAppTheme.kBlue
                              : EaselAppTheme.kLightWhiteBackground,
                          textColor:
                              provider.isFreeDrop != FreeDrop.unselected ? EaselAppTheme.kWhite : EaselAppTheme.kGrey,
                          onPressed: () async {
                            if (provider.isFreeDrop != FreeDrop.unselected) {
                              FocusScope.of(context).unfocus();
                              validateAndUpdatePrice(moveNextPage: true);
                            }
                          },
                          cuttingHeight: 15.h,
                          clipperType: ClipperType.bottomLeftTopRight,
                          isShadow: false,
                          fontWeight: provider.isFreeDrop != FreeDrop.unselected ? FontWeight.w700 : FontWeight.normal,
                          fontSize: 14,
                          btnHeight: 35,
                        ),
                        VerticalSpace(10.h),
                        Center(
                          child: InkWell(
                            key: const Key(kSaveAsDraftPriceKey),
                            onTap: () {
                              if (provider.isFreeDrop == FreeDrop.unselected) {
                                Navigator.pop(context);
                                return;
                              }
                              FocusScope.of(context).unfocus();
                              validateAndUpdatePrice(moveNextPage: false);
                            },
                            child: Text(
                              LocaleKeys.save_as_draft.tr(),
                              style: TextStyle(
                                color: EaselAppTheme.kLightGreyText,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        VerticalSpace(5.h),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> validateAndUpdatePrice({required bool moveNextPage}) async {
    final navigator = Navigator.of(context);
    final HomeViewModel homeViewModel = context.read<HomeViewModel>();

    if (!_formKey.currentState!.validate()) {
      return;
    }
    GetIt.I.get<CreatorHubViewModel>().changeSelectedCollection(CollectionType.draft);

    if (context.read<EaselProvider>().isFreeDrop == FreeDrop.yes) {
      if (_royaltiesFieldError.value.isNotEmpty || _noOfEditionsFieldError.value.isNotEmpty) return;
      await context.read<EaselProvider>().updateNftFromPrice(nft!.id!);
      moveNextPage ? homeViewModel.nextPage() : navigator.pop();

      return;
    }
    if (_royaltiesFieldError.value.isNotEmpty ||
        _noOfEditionsFieldError.value.isNotEmpty ||
        _priceFieldError.value.isNotEmpty) return;
    await context.read<EaselProvider>().updateNftFromPrice(nft!.id!);
    moveNextPage ? homeViewModel.nextPage() : navigator.pop();
  }
}
