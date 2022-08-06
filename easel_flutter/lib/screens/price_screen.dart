import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/repository/repository.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../widgets/easel_price_input_field.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final _formKey = GlobalKey<FormState>();
  var repository = GetIt.I.get<Repository>();
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
    nft = repository.getCacheDynamicType(key: nftKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<EaselProvider>(builder: (_, provider, __) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                const VerticalSpace(20),
                MyStepsIndicator(currentStep: homeViewModel.currentStep),
                const VerticalSpace(5),
                StepLabels(currentPage: homeViewModel.currentPage, currentStep: homeViewModel.currentStep),
                const VerticalSpace(10),
                const VerticalSpace(20),
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
                              )),
                        )),
                    ValueListenableBuilder(
                      valueListenable: homeViewModel.currentPage,
                      builder: (_, int currentPage, __) {
                        return Text(
                          homeViewModel.pageTitles[homeViewModel.currentPage.value],
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kDarkText),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ValueListenableBuilder(
                          valueListenable: homeViewModel.currentPage,
                          builder: (_, int currentPage, __) => Padding(
                                padding: EdgeInsets.only(right: 20.w),
                                child: InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    validateAndUpdatePrice(true);
                                  },
                                  child: Text(
                                    "next".tr(),
                                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: EaselAppTheme.kBlue),
                                  ),
                                ),
                              )),
                    )
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
                        "is_this_free".tr(),
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(children: [
                        InkWell(
                          onTap: () {
                            provider.updateIsFreeDropStatus(true);
                          },
                          child: Container(
                            width: 140.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: provider.isFreeDrop == true ? EaselAppTheme.kBlue : EaselAppTheme.kTransparent,
                              border: Border.all(color: provider.isFreeDrop == true ? EaselAppTheme.kBlue : EaselAppTheme.kBlack, width: 3.w),
                            ),
                            child: Center(
                              child: Text(
                                "yes".tr(),
                                style: TextStyle(
                                  color: provider.isFreeDrop == true ? EaselAppTheme.kWhite : EaselAppTheme.kBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        InkWell(
                          onTap: () {
                            provider.updateIsFreeDropStatus(false);
                          },
                          child: Container(
                            width: 140.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: provider.isFreeDrop == false ? EaselAppTheme.kBlue : EaselAppTheme.kTransparent,
                              border: Border.all(color: provider.isFreeDrop == false ? EaselAppTheme.kBlue : EaselAppTheme.kBlack, width: 3.w),
                            ),
                            child: Center(
                              child: Text(
                                "no".tr(),
                                style: TextStyle(
                                  color: provider.isFreeDrop == false ? EaselAppTheme.kWhite : EaselAppTheme.kBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      if (!provider.isFreeDrop)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VerticalSpace(20.h),
                            EaselPriceInputField(
                              key: ValueKey("${provider.selectedDenom.name}-amount"),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(kMaxPriceLength), provider.selectedDenom.getFormatter()],
                              controller: provider.priceController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  _priceFieldError.value = kEnterPriceText;
                                  return;
                                }
                                if (double.parse(value.replaceAll(",", "")) < kMinValue) {
                                  _priceFieldError.value = "$kMinIsText $kMinValue";
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
                            Text(
                              kNetworkFeeWarnText,
                              style: TextStyle(color: EaselAppTheme.kLightPurple, fontSize: 14.sp, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      VerticalSpace(20.h),
                      EaselTextField(
                        label: kRoyaltiesText,
                        hint: kRoyaltyHintText,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                          AmountFormatter(
                            maxDigits: 2,
                          )
                        ],
                        controller: provider.royaltyController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            _royaltiesFieldError.value = kEnterRoyaltyText;
                            return;
                          }
                          if (int.parse(value) > kMaxRoyalty) {
                            _royaltiesFieldError.value = "$kRoyaltyRangeText $kMinRoyalty-$kMaxRoyalty %";
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
                      Text(
                        "$kRoyaltyNoteText “$kMinRoyalty”.",
                        style: TextStyle(color: EaselAppTheme.kLightPurple, fontWeight: FontWeight.w800, fontSize: 14.sp),
                      ),
                      VerticalSpace(20.h),
                      EaselTextField(
                        key: ValueKey(provider.selectedDenom.name),
                        label: kNoOfEditionText,
                        hint: kHintNoEdition,
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
                            _noOfEditionsFieldError.value = kEnterEditionText;
                            return;
                          }
                          if (int.parse(value.replaceAll(",", "")) < kMinEditionValue) {
                            _noOfEditionsFieldError.value = "$kMinIsText $kMinEditionValue";
                            return;
                          }
                          if (int.parse(value.replaceAll(",", "")) > kMaxEdition) {
                            _noOfEditionsFieldError.value = "$kMaxIsTextText $kMaxEdition";
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
                      Text(
                        "${NumberFormat.decimalPattern().format(kMaxEdition)} $kMaxText",
                        style: TextStyle(color: EaselAppTheme.kLightPurple, fontSize: 14.sp, fontWeight: FontWeight.w800),
                      ),
                      VerticalSpace(20.h),
                      ClippedButton(
                        title: "save_as_draft".tr(),
                        bgColor: EaselAppTheme.kBlue,
                        textColor: EaselAppTheme.kWhite,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          validateAndUpdatePrice(false);
                        },
                        cuttingHeight: 15.h,
                        clipperType: ClipperType.bottomLeftTopRight,
                        isShadow: false,
                        fontWeight: FontWeight.w700,
                      ),
                      VerticalSpace(10.h),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "discard".tr(),
                            style: TextStyle(color: EaselAppTheme.kLightGreyText, fontSize: 14.sp, fontWeight: FontWeight.w700),
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
    );
  }

  void validateAndUpdatePrice(bool moveNextPage) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (context.read<EaselProvider>().isFreeDrop) {
      if (_royaltiesFieldError.value.isNotEmpty || _noOfEditionsFieldError.value.isNotEmpty) return;
      await context.read<EaselProvider>().updateNftFromPrice(nft!.id!);
      moveNextPage ? context.read<HomeViewModel>().nextPage() : Navigator.pop(context);
    } else {
      if (_royaltiesFieldError.value.isNotEmpty || _noOfEditionsFieldError.value.isNotEmpty || _priceFieldError.value.isNotEmpty) return;
      await context.read<EaselProvider>().updateNftFromPrice(nft!.id!);
      moveNextPage ? context.read<HomeViewModel>().nextPage() : Navigator.pop(context);
    }
  }
}
