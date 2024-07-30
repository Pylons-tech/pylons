import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/screens/custom_widgets/bottom_buttons.dart';
import 'package:evently/screens/custom_widgets/page_app_bar.dart';
import 'package:evently/screens/custom_widgets/step_labels.dart';
import 'package:evently/screens/custom_widgets/steps_indicator.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/enums.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/route_util.dart';
import 'package:evently/utils/screen_responsive.dart';
import 'package:evently/utils/space_utils.dart';
import 'package:evently/viewmodels/create_event_viewmodel.dart';
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
  final ValueNotifier<String> _numberOfTicketsFieldError = ValueNotifier("");

  @override
  void dispose() {
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
        body: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Consumer<EventlyProvider>(builder: (_, provider, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const VerticalSpace(20),
                    MyStepsIndicator(currentStep: homeViewModel.currentStep),
                    const VerticalSpace(5),
                    StepLabels(currentPage: homeViewModel.currentPage, currentStep: homeViewModel.currentStep),
                    const VerticalSpace(10),
                    const VerticalSpace(20),
                    PageAppBar(
                      onPressBack: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        homeViewModel.previousPage();
                      },
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
                          SizedBox(height: 10.h),
                          Row(children: [
                            InkWell(
                              onTap: () => provider.setFreeDrop = FreeDrop.yes,
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
                              onTap: () => provider.setFreeDrop = FreeDrop.no,
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
                              children: provider.isFreeDrop == FreeDrop.no
                                  ? [
                                      VerticalSpace(20.h),
                                      EventlyPriceInputField(
                                        key: ValueKey("${provider.selectedDenom.name}-amount"),
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(kMaxPriceLength), provider.selectedDenom.getFormatter()],
                                        onChange: (_) => provider.setPrice = int.parse(_),
                                        controller: TextEditingController(text: provider.price.toString())
                                          ..selection = TextSelection.fromPosition(
                                            TextPosition(offset: provider.price.toString().length),
                                          ),
                                      ),
                                      Text(
                                        LocaleKeys.network_fee_listed_price_occur_on_chain.tr(),
                                        style: TextStyle(color: EventlyAppTheme.kTextDarkPurple, fontSize: 14.sp, fontWeight: FontWeight.w800),
                                      ),
                                      VerticalSpace(20.h),
                                      EventlyTextField(
                                        keyboardType: TextInputType.number,
                                        label: LocaleKeys.number_tickets.tr(),
                                        controller: TextEditingController(text: provider.numberOfTickets.toString())
                                          ..selection = TextSelection.fromPosition(
                                            TextPosition(offset: provider.numberOfTickets.toString().length),
                                          ),
                                        textCapitalization: TextCapitalization.sentences,
                                        onChanged: (_) => _.isEmpty ? provider.setNumberOfTickets = 0 : provider.setNumberOfTickets = int.parse(_),
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
                                          style: TextStyle(color: EventlyAppTheme.kTextDarkPurple, fontSize: 14.sp, fontWeight: FontWeight.w800),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ]
                                  : [
                                      VerticalSpace(20.h),
                                      EventlyTextField(
                                        keyboardType: TextInputType.number,
                                        label: LocaleKeys.number_tickets.tr(),
                                        controller: TextEditingController(text: provider.numberOfTickets.toString())
                                          ..selection = TextSelection.fromPosition(
                                            TextPosition(offset: provider.numberOfTickets.toString().length),
                                          ),
                                        textCapitalization: TextCapitalization.sentences,
                                        onChanged: (_) => _.isEmpty ? provider.setNumberOfTickets = 0 : provider.setNumberOfTickets = int.parse(_),
                                      ),
                                    ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                VerticalSpace(20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: BottomButtons(
                    onPressContinue: () {
                      homeViewModel.nextPage();
                    },
                    onPressSaveDraft: () {
                      final navigator = Navigator.of(context);
                      provider.saveAsDraft(
                        onCompleted: () => navigator.popUntil((route) => route.settings.name == RouteUtil.kRouteEventHub),
                        uploadStep: UploadStep.price,
                      );
                    },
                    isContinueEnable: provider.isFreeDrop == FreeDrop.unselected
                        ? false
                        : provider.isFreeDrop == FreeDrop.yes
                        ? (provider.numberOfTickets > 0 && provider.numberOfTickets <= 1000)
                        : (provider.numberOfTickets > 0 && provider.numberOfTickets <= 1000 && provider.price > 0),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    ));
  }
}
