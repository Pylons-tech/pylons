import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/screens/custom_widgets/bottom_buttons.dart';
import 'package:evently/screens/custom_widgets/page_app_bar.dart';
import 'package:evently/screens/custom_widgets/step_labels.dart';
import 'package:evently/screens/custom_widgets/steps_indicator.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/enums.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/route_util.dart';
import 'package:evently/utils/space_utils.dart';
import 'package:evently/viewmodels/create_event_viewmodel.dart';
import 'package:evently/widgets/evently_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final createEventViewModel = context.watch<CreateEventViewModel>();
    final provider = context.watch<EventlyProvider>();

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
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
                                provider.setStartDate = _formatDateToIso(val);
                                // Validate dates only if both dates are set
                                if (provider.endDate.isNotEmpty) {
                                  _validateDates(provider);
                                }
                              });
                            },
                            child: EventlyTextField(
                              enable: false,
                              label: LocaleKeys.start_date.tr(),
                              controller: TextEditingController(text: _formatDateDisplay(provider.startDate)),
                              textCapitalization: TextCapitalization.sentences,
                              imageBackground: PngUtils.textFieldBottomLeft,
                              inputTextColor: EventlyAppTheme.kTextDarkBlue,
                            ),
                          ),
                        ),
                        HorizontalSpace(20.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _showDatePicker(onSelected: (DateTime? val) {
                                if (val == null) return;
                                provider.setEndDate = _formatDateToIso(val);
                                // Validate dates only if both dates are set
                                if (provider.startDate.isNotEmpty) {
                                  _validateDates(provider);
                                }
                              });
                            },
                            child: EventlyTextField(
                              enable: false,
                              label: LocaleKeys.end_date.tr(),
                              controller: TextEditingController(text: _formatDateDisplay(provider.endDate)),
                              textCapitalization: TextCapitalization.sentences,
                              imageBackground: PngUtils.textFieldTopRight,
                              inputTextColor: EventlyAppTheme.kTextDarkBlue,
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
                              _showTimePicker(onSelected: (TimeOfDay? timeOfDay) {
                                if (timeOfDay == null) return;
                                final currentTime = DateTime.now();
                                final time = currentTime.copyWith(hour: timeOfDay.hour, minute: timeOfDay.minute);
                                provider.setStartTime = _formatTimeToIso(time);
                              });
                            },
                            child: EventlyTextField(
                              enable: false,
                              label: LocaleKeys.start_time.tr(),
                              controller: TextEditingController(text: provider.startTime),
                              textCapitalization: TextCapitalization.sentences,
                              imageBackground: PngUtils.textFieldBottomLeft,
                              inputTextColor: EventlyAppTheme.kTextDarkBlue,
                            ),
                          ),
                        ),
                        HorizontalSpace(20.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _showTimePicker(onSelected: (TimeOfDay? timeOfDay) {
                                if (timeOfDay == null) return;
                                final currentTime = DateTime.now();
                                final time = currentTime.copyWith(hour: timeOfDay.hour, minute: timeOfDay.minute);
                                provider.setEndTime = _formatTimeToIso(time);
                              });
                            },
                            child: EventlyTextField(
                              enable: false,
                              label: LocaleKeys.end_time.tr(),
                              controller: TextEditingController(text: provider.endTime),
                              textCapitalization: TextCapitalization.sentences,
                              imageBackground: PngUtils.textFieldTopRight,
                              inputTextColor: EventlyAppTheme.kTextDarkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    VerticalSpace(20.h),
                    EventlyTextField(
                      onChanged: (val) => provider.setLocation = val,
                      label: LocaleKeys.location.tr(),
                      hint: LocaleKeys.search_location.tr(),
                      controller: TextEditingController(text: provider.location)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: provider.location.length),
                        ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    VerticalSpace(20.h),
                    EventlyTextField(
                      onChanged: (val) => provider.setDescription = val,
                      label: LocaleKeys.description.tr(),
                      hint: LocaleKeys.what_event_for.tr(),
                      controller: TextEditingController(text: provider.description)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: provider.description.length),
                        ),
                      textCapitalization: TextCapitalization.sentences,
                      noOfLines: 4,
                    ),
                    const VerticalSpace(40),
                    BottomButtons(
                      onPressContinue: () {
                        if (_validateDates(provider)) {
                          createEventViewModel.nextPage();
                        } else {
                          _showSnackBarWithPostFrameCallback('End of event cannot be before start of event!');
                        }
                      },
                      onPressSaveDraft: () {
                        final navigator = Navigator.of(context);
                        if (_validateDates(provider)) {
                          provider.saveAsDraft(
                            onCompleted: () => navigator.popUntil((route) => route.settings.name == RouteUtil.kRouteEventHub),
                            uploadStep: UploadStep.detail,
                          );
                        } else {
                          _showSnackBarWithPostFrameCallback('End of event cannot be before start of event!');
                        }
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
        ),
      ),
    );
  }

  _showDatePicker({required ValueChanged<DateTime?> onSelected}) {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2099, 12),
    ).then((value) => onSelected(value));
  }

  _showTimePicker({required ValueChanged<TimeOfDay?> onSelected}) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) => onSelected(value));
  }

  String _formatDateToIso(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String _formatDateDisplay(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
      return DateFormat.yMMMMd('en_US').format(parsedDate);
    } catch (e) {
      return '';
    }
  }

  String _formatTimeToIso(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('HH:mm').format(dateTime);
  }

  bool _validateDates(EventlyProvider provider) {
    if (provider.startDate.isEmpty || provider.endDate.isEmpty) {
      return true; // Dates are not set yet, so no validation needed
    }

    try {
      final DateTime start = DateFormat('yyyy-MM-dd').parse(provider.startDate);
      final DateTime end = DateFormat('yyyy-MM-dd').parse(provider.endDate);
      if (end.isBefore(start)) {
        return false; // End date is before start date
      }
      // Check times if the dates are the same
      if (provider.startDate.compareTo(provider.endDate) == 0) {
        final DateTime startTime = DateFormat('HH:mm').parse(provider.startTime);
        final DateTime endTime = DateFormat('HH:mm').parse(provider.endTime);

        if (endTime.isBefore(startTime)) {
          return false; // End time is before start time on the same day
        }
      }
    } catch (e) {
      return false; // Invalid date format
    }

    return true; // Dates are valid
  }

  void _showSnackBarWithPostFrameCallback(String message) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ));
    });
  }
}
