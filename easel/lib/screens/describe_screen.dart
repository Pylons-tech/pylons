import 'dart:async';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/custom_widgets/initial_draft_detail_dialog.dart';
import 'package:easel_flutter/screens/custom_widgets/step_labels.dart';
import 'package:easel_flutter/screens/custom_widgets/steps_indicator.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/viewmodels/home_viewmodel.dart';
import 'package:easel_flutter/widgets/clipped_button.dart';
import 'package:easel_flutter/widgets/easel_hashtag_input_field.dart';
import 'package:easel_flutter/widgets/easel_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class DescribeScreen extends StatefulWidget {
  const DescribeScreen({Key? key}) : super(key: key);

  @override
  State<DescribeScreen> createState() => _DescribeScreenState();
}

class _DescribeScreenState extends State<DescribeScreen> {
  var repository = GetIt.I.get<Repository>();
  EaselProvider provider = GetIt.I.get<EaselProvider>();
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<String> _artNameFieldError = ValueNotifier("");
  final ValueNotifier<String> _artistNameFieldError = ValueNotifier("");
  final ValueNotifier<String> _descriptionFieldError = ValueNotifier("");

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    provider.nft = repository.getCacheDynamicType(key: nftKey);
    repository.logUserJourney(screenName: AnalyticsScreenEvents.describeScreen);
    String from = "";
    from = context.read<HomeViewModel>().from!;

    scheduleMicrotask(() {
      provider.toCheckSavedArtistName();
      if (from != kDraft) {
        DraftDetailDialog(context: context, easelProvider: provider, onClose: () {}).show();
      }
    });
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  FocusScope.of(context).unfocus();
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  Navigator.pop(context);
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
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700, color: EaselAppTheme.kDarkText),
                        );
                      },
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
                      EaselTextField(
                        label: "give_nft_a_name".tr(),
                        hint: "nft_name_hint".tr(),
                        controller: provider.artNameController,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            _artNameFieldError.value = "enter_nft_name".tr();
                            return;
                          }
                          if (value.length <= kMinNFTName) {
                            _artNameFieldError.value = "nft_remaining_characters".tr(args: [kMinNFTName.toString()]);
                            return;
                          }
                          _artNameFieldError.value = '';
                          return null;
                        },
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: _artNameFieldError,
                        builder: (_, String artNameFieldError, __) {
                          if (artNameFieldError.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                            child: Text(
                              artNameFieldError,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                      VerticalSpace(20.h),
                      EaselTextField(
                        label: "your_name_as_the_artist".tr(),
                        hint: "artist_hint".tr(),
                        controller: provider.artistNameController,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            _artistNameFieldError.value = 'enter_artist_name'.tr();
                          } else {
                            _artistNameFieldError.value = '';
                          }
                          return null;
                        },
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: _artistNameFieldError,
                        builder: (_, String artistNameFieldError, __) {
                          if (artistNameFieldError.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                            child: Text(
                              artistNameFieldError,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                      VerticalSpace(20.h),
                      EaselTextField(
                        label: "describe_your_nft".tr(),
                        hint: "desc_nft_hint".tr(),
                        noOfLines: 5,
                        controller: provider.descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        inputFormatters: [LengthLimitingTextInputFormatter(kMaxDescription)],
                        validator: (value) {
                          if (value!.isEmpty) {
                            _descriptionFieldError.value = "enter_nft_description".tr();
                            return;
                          }
                          if (value.length <= kMinDescription) {
                            _descriptionFieldError.value = "${"enter_more_than".tr()} $kMinDescription ${"characters".tr()}";
                            return;
                          }
                          _descriptionFieldError.value = '';
                          return null;
                        },
                      ),
                      ValueListenableBuilder<String>(
                          valueListenable: _descriptionFieldError,
                          builder: (_, String descriptionFieldError, __) {
                            if (descriptionFieldError.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                              child: Text(
                                descriptionFieldError,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }),
                      ValueListenableBuilder(
                          valueListenable: provider.descriptionController,
                          builder: (_, TextEditingValue controller, __) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${kMaxDescription - controller.text.length} ${"character_limit".tr()}",
                                    style: TextStyle(color: EaselAppTheme.kLightPurple, fontSize: 14.sp, fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            );
                          }),
                      VerticalSpace(20.h),
                      const EaselHashtagInputField(),
                      VerticalSpace(20.h),
                      ClippedButton(
                        title: "continue".tr(),
                        bgColor: EaselAppTheme.kBlue,
                        textColor: EaselAppTheme.kWhite,
                        onPressed: () {
                          validateAndUpdateDescription(true);
                        },
                        cuttingHeight: 15.h,
                        clipperType: ClipperType.bottomLeftTopRight,
                        isShadow: false,
                        fontWeight: FontWeight.w700,
                      ),
                      VerticalSpace(10.h),
                      Center(
                        child: InkWell(
                          key: const Key(kSaveAsDraftDescKey),
                          onTap: () {
                            validateAndUpdateDescription(false);
                          },
                          child: Text(
                            "save_as_draft".tr(),
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

  void validateAndUpdateDescription(moveNextPage) {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if ((_artNameFieldError.value.isNotEmpty || _artistNameFieldError.value.isNotEmpty || _descriptionFieldError.value.isNotEmpty)) {
      return;
    }
    GetIt.I.get<CreatorHubViewModel>().changeSelectedCollection(CollectionType.draft);

    context.read<EaselProvider>().updateNftFromDescription(provider.nft.id!);
    context.read<EaselProvider>().saveArtistName(provider.artistNameController.text.trim());
    moveNextPage ? context.read<HomeViewModel>().nextPage() : Navigator.pop(context);
  }
}
