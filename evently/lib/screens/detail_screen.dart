import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/screens/custom_widgets/step_labels.dart';
import 'package:evently/screens/custom_widgets/steps_indicator.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/space_utils.dart';
import 'package:evently/viewmodels/create_event_viewmodel.dart';
import 'package:evently/widgets/clipped_button.dart';
import 'package:evently/widgets/easel_text_field.dart';
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
  final ValueNotifier<String> _startDateFieldError = ValueNotifier("");
  final ValueNotifier<String> _endDateFieldError = ValueNotifier("");
  final ValueNotifier<String> _startTimeFieldError = ValueNotifier("");
  final ValueNotifier<String> _endTimeFieldError = ValueNotifier("");
  final ValueNotifier<String> _descriptionFieldError = ValueNotifier("");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final createEventViewModel = context.watch<CreateEventViewModel>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpace(20),
              MyStepsIndicator(currentStep: createEventViewModel.currentStep),
              const VerticalSpace(5),
              StepLabels(currentPage: createEventViewModel.currentPage, currentStep: createEventViewModel.currentStep),
              const VerticalSpace(10),
              const VerticalSpace(20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: ValueListenableBuilder(
                        valueListenable: createEventViewModel.currentPage,
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
                                color: EventlyAppTheme.kGrey,
                              ),
                            )),
                      )),
                  ValueListenableBuilder(
                    valueListenable: createEventViewModel.currentPage,
                    builder: (_, int currentPage, __) {
                      return Text(
                        createEventViewModel.pageTitles[createEventViewModel.currentPage.value],
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700, color: EventlyAppTheme.kDarkText),
                      );
                    },
                  ),
                ],
              ),
              const VerticalSpace(20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              EventlyTextField(
                                label: LocaleKeys.start_date.tr(),
                                controller: TextEditingController(),
                                textCapitalization: TextCapitalization.sentences,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              ValueListenableBuilder<String>(
                                valueListenable: _startDateFieldError,
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
                            ],
                          ),
                        ),
                        HorizontalSpace(20.w),
                        Expanded(
                          child: Column(
                            children: [
                              EventlyTextField(
                                label: LocaleKeys.end_date.tr(),
                                controller: TextEditingController(),
                                textCapitalization: TextCapitalization.sentences,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              ValueListenableBuilder<String>(
                                valueListenable: _endDateFieldError,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    VerticalSpace(20.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              EventlyTextField(
                                label: LocaleKeys.start_time.tr(),
                                controller: TextEditingController(),
                                textCapitalization: TextCapitalization.sentences,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              ValueListenableBuilder<String>(
                                valueListenable: _startTimeFieldError,
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
                            ],
                          ),
                        ),
                        HorizontalSpace(20.w),
                        Expanded(
                          child: Column(
                            children: [
                              EventlyTextField(
                                label: LocaleKeys.end_time.tr(),
                                controller: TextEditingController(),
                                textCapitalization: TextCapitalization.sentences,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              ValueListenableBuilder<String>(
                                valueListenable: _endTimeFieldError,
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
                            ],
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
                    ValueListenableBuilder<String>(
                      valueListenable: _startDateFieldError,
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
                    ValueListenableBuilder<String>(
                      valueListenable: _descriptionFieldError,
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
                    ClippedButton(
                      title: LocaleKeys.continue_key.tr(),
                      bgColor: EventlyAppTheme.kBlue,
                      textColor: EventlyAppTheme.kWhite,
                      onPressed: () {
                        createEventViewModel.nextPage();
                      },
                      cuttingHeight: 15.h,
                      clipperType: ClipperType.bottomLeftTopRight,
                      isShadow: false,
                      fontWeight: FontWeight.w700,
                    ),
                    VerticalSpace(10.h),
                    Center(
                      child: InkWell(
                        onTap: () {},
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
        ),
      ),
    );
  }
}