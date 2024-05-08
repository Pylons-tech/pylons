import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/screens/custom_widgets/step_labels.dart';
import 'package:evently/screens/custom_widgets/steps_indicator.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/route_util.dart';
import 'package:evently/utils/screen_responsive.dart';
import 'package:evently/utils/space_utils.dart';
import 'package:evently/viewmodels/create_event_viewmodel.dart';
import 'package:evently/widgets/clipped_button.dart';
import 'package:evently/widgets/evently_price_input_field.dart';
import 'package:evently/widgets/evently_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<String> _numberOfTicketsFieldError = ValueNotifier("");

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<CreateEventViewModel>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<EventlyProvider>(builder: (_, provider, __) {
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
                                  color: EventlyAppTheme.kGrey,
                                ),
                              )),
                        )),
                    ValueListenableBuilder(
                      valueListenable: homeViewModel.currentPage,
                      builder: (_, int currentPage, __) {
                        return Text(
                          homeViewModel.pageTitles[homeViewModel.currentPage.value],
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700, color: EventlyAppTheme.kDarkText),
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
                      Text(
                        LocaleKeys.is_free_drop.tr(),
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(children: [
                        InkWell(
                          onTap: () {
                            // provider.updateIsFreeDropStatus(FreeDrop.yes);
                          },
                          child: Container(
                            width: 140.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: provider.isFreeDrop == FreeDrop.yes ? EventlyAppTheme.kBlue : EventlyAppTheme.kTransparent,
                              border: Border.all(color: provider.isFreeDrop == FreeDrop.yes ? EventlyAppTheme.kBlue : EventlyAppTheme.kBlack, width: 2.w),
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.yes.tr(),
                                style: TextStyle(
                                  color: provider.isFreeDrop == FreeDrop.yes ? EventlyAppTheme.kWhite : EventlyAppTheme.kBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 140.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: provider.isFreeDrop == FreeDrop.no ? EventlyAppTheme.kBlue : EventlyAppTheme.kTransparent,
                              border: Border.all(color: provider.isFreeDrop == FreeDrop.no ? EventlyAppTheme.kBlue : EventlyAppTheme.kBlack, width: 2.w),
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.no.tr(),
                                style: TextStyle(
                                  color: provider.isFreeDrop == FreeDrop.no ? EventlyAppTheme.kWhite : EventlyAppTheme.kBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      if (provider.isFreeDrop != FreeDrop.unselected)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (provider.isFreeDrop == FreeDrop.no)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VerticalSpace(20.h),
                                  EventlyPriceInputField(
                                    key: ValueKey("${provider.selectedDenom.name}-amount"),
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(kMaxPriceLength), provider.selectedDenom.getFormatter()],
                                    controller: provider.priceController,
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                  Text(
                                    LocaleKeys.network_fee_listed_price_occur_on_chain.tr(),
                                    style: TextStyle(color: EventlyAppTheme.kLightPurple, fontSize: 14.sp, fontWeight: FontWeight.w800),
                                  ),
                                  VerticalSpace(20.h),
                                  EventlyTextField(
                                    label: LocaleKeys.number_tickets.tr(),
                                    controller: TextEditingController(),
                                    textCapitalization: TextCapitalization.sentences,
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: _numberOfTicketsFieldError,
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
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      LocaleKeys.maximum_1000.tr(),
                                      style: TextStyle(color: EventlyAppTheme.kLightPurple, fontSize: 14.sp, fontWeight: FontWeight.w800),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ScreenResponsive(
                        mobileScreen: (_) => VerticalSpace(0.1.sh),
                        tabletScreen: (_) => VerticalSpace(0.05.sh),
                      ),
                      VerticalSpace(20.h),
                      ClippedButton(
                        title: LocaleKeys.continue_key.tr(),
                        bgColor: provider.isFreeDrop != FreeDrop.unselected ? EventlyAppTheme.kBlue : EventlyAppTheme.kPurple03,
                        textColor: EventlyAppTheme.kWhite,
                        onPressed: () async {
                          Navigator.of(context).pushNamed(RouteUtil.kHostTicketPreview);
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
                            Navigator.of(context).pushNamed(RouteUtil.kHostTicketPreview);
                          },
                          child: Text(
                            LocaleKeys.save_draft.tr(),
                            style: TextStyle(color: EventlyAppTheme.kLightGreyText, fontSize: 14.sp, fontWeight: FontWeight.w700),
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
}
