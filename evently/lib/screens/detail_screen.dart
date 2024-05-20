import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/screens/custom_widgets/bottom_buttons.dart';
import 'package:evently/screens/custom_widgets/page_app_bar.dart';
import 'package:evently/screens/custom_widgets/step_labels.dart';
import 'package:evently/screens/custom_widgets/steps_indicator.dart';
import 'package:evently/utils/enums.dart';
import 'package:evently/utils/route_util.dart';
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
        builder: (_, provider, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalSpace(20),
            MyStepsIndicator(currentStep: createEventViewModel.currentStep),
            StepLabels(currentPage: createEventViewModel.currentPage, currentStep: createEventViewModel.currentStep),
            const VerticalSpace(20),
            PageAppBar(onPressBack: () {
              createEventViewModel.previousPage();
            }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            _showDatePicker(onSelected: (DateTime? val) {
                              if (val == null) return;
                              provider.setStartDate = DateFormat("dd-MM-yyyy").format(val);
                            });
                          },
                          child: EventlyTextField(
                            enable: false,
                            label: LocaleKeys.start_date.tr(),
                            controller: TextEditingController(text: provider.startDate),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                      ),
                      HorizontalSpace(20.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showDatePicker(onSelected: (DateTime? val) {
                              if (val == null) return;
                              provider.setEndDate = DateFormat("dd-MM-yyyy").format(val);
                            });
                          },
                          child: EventlyTextField(
                            enable: false,
                            label: LocaleKeys.end_date.tr(),
                            controller: TextEditingController(text: provider.endDate),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  VerticalSpace(20.h),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showTimerPicker(onSelected: (TimeOfDay? timeOfDay) {
                              if (timeOfDay == null) return;
                              provider.setStartTime = '${timeOfDay.hour}:${timeOfDay.minute}';
                            });
                          },
                          child: EventlyTextField(
                            enable: false,
                            label: LocaleKeys.start_time.tr(),
                            controller: TextEditingController(text: provider.startTime),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                      ),
                      HorizontalSpace(20.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showTimerPicker(onSelected: (TimeOfDay? timeOfDay) {
                              if (timeOfDay == null) return;
                              provider.setEndTime = '${timeOfDay.hour}:${timeOfDay.minute}';
                            });
                          },
                          child: EventlyTextField(
                            enable: false,
                            label: LocaleKeys.end_time.tr(),
                            controller: TextEditingController(text: provider.endTime),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  VerticalSpace(20.h),
                  EventlyTextField(
                    onChanged: (_) => provider.setLocation = _,
                    label: LocaleKeys.location.tr(),
                    hint: LocaleKeys.search_location.tr(),
                    controller: TextEditingController(text: provider.location)
                      ..selection = TextSelection.fromPosition(
                        TextPosition(offset: provider.location.length),
                      ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      return null;
                    },
                  ),
                  VerticalSpace(20.h),
                  EventlyTextField(
                    onChanged: (_) => provider.setDescription = _,
                    label: LocaleKeys.description.tr(),
                    hint: LocaleKeys.what_event_for.tr(),
                    controller: TextEditingController(text: provider.description)
                      ..selection = TextSelection.fromPosition(
                        TextPosition(offset: provider.description.length),
                      ),
                    textCapitalization: TextCapitalization.sentences,
                    noOfLines: 4,
                  ),
                  const VerticalSpace(80),
                  BottomButtons(
                    onPressContinue: () {
                      createEventViewModel.nextPage();
                    },
                    onPressSaveDraft: () {
                      final navigator = Navigator.of(context);
                      provider.saveAsDraft(
                        onCompleted: () => navigator.popUntil((route) => route.settings.name == RouteUtil.kRouteEventHub),
                        uploadStep: UploadStep.detail,
                      );
                    },
                    isContinueEnable: provider.startDate.isNotEmpty &&
                        provider.endDate.isNotEmpty &&
                        provider.startTime.isNotEmpty &&
                        provider.endTime.isNotEmpty &&
                        provider.description.isNotEmpty &&
                        provider.location.isNotEmpty,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  _showTimerPicker({required ValueChanged<TimeOfDay?> onSelected}) {
    showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    ).then((value) => onSelected(value!));
  }

  _showDatePicker({required ValueChanged<DateTime?> onSelected}) {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now(),
    ).then((value) => onSelected(value!));
  }
}
