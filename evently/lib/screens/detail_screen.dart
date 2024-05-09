import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/screens/custom_widgets/step_labels.dart';
import 'package:evently/screens/custom_widgets/steps_indicator.dart';
import 'package:evently/screens/price_screen.dart';
import 'package:evently/utils/space_utils.dart';
import 'package:evently/viewmodels/create_event_viewmodel.dart';
import 'package:evently/widgets/evently_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final createEventViewModel = context.watch<CreateEventViewModel>();

    return Scaffold(
      body: SingleChildScrollView(
          child: Consumer<EventlyProvider>(
        builder: (_, provider, __) => Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyStepsIndicator(currentStep: createEventViewModel.currentStep),
              StepLabels(currentPage: createEventViewModel.currentPage, currentStep: createEventViewModel.currentStep),
              PageAppBar(onPressBack: () {}),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: EventlyTextField(
                            enable: false,
                            label: LocaleKeys.start_date.tr(),
                            controller: TextEditingController(),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                        HorizontalSpace(20.w),
                        Expanded(
                          child: EventlyTextField(
                            enable: false,
                            label: LocaleKeys.end_date.tr(),
                            controller: TextEditingController(),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    VerticalSpace(20.h),
                    Row(
                      children: [
                        Expanded(
                          child: EventlyTextField(
                            enable: false,
                            label: LocaleKeys.start_time.tr(),
                            controller: TextEditingController(),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                        HorizontalSpace(20.w),
                        Expanded(
                          child: EventlyTextField(
                            enable: false,
                            label: LocaleKeys.end_time.tr(),
                            controller: TextEditingController(),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    VerticalSpace(20.h),
                    EventlyTextField(
                      label: LocaleKeys.location.tr(),
                      hint: LocaleKeys.search_location.tr(),
                      controller: TextEditingController(),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        return null;
                      },
                    ),
                    VerticalSpace(20.h),
                    EventlyTextField(
                      label: LocaleKeys.description.tr(),
                      hint: LocaleKeys.what_event_for.tr(),
                      controller: TextEditingController(),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        return null;
                      },
                      noOfLines: 4,
                    ),
                    BottomButtons(
                      onPressContinue: () {},
                      onPressSaveDraft: () {},
                      isContinueEnable: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
