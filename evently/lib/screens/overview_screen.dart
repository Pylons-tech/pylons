import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/screens/custom_widgets/bottom_buttons.dart';
import 'package:evently/screens/custom_widgets/page_app_bar.dart';
import 'package:evently/screens/custom_widgets/step_labels.dart';
import 'package:evently/screens/custom_widgets/steps_indicator.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/space_utils.dart';
import 'package:evently/viewmodels/create_event_viewmodel.dart';
import 'package:evently/widgets/evently_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class OverViewScreen extends StatefulWidget {
  const OverViewScreen({super.key});

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
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
              const VerticalSpace(20),
              MyStepsIndicator(currentStep: createEventViewModel.currentStep),
              StepLabels(currentPage: createEventViewModel.currentPage, currentStep: createEventViewModel.currentStep),
              const VerticalSpace(20),
              PageAppBar(onPressBack: () {
                Navigator.of(context).pop();
              }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EventlyTextField(
                      controller: TextEditingController(text: provider.eventName),
                      onChanged: (_) => provider.setEventName = _,
                      label: LocaleKeys.event_name.tr(),
                      hint: LocaleKeys.what_your_event_called.tr(),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    VerticalSpace(20.h),
                    EventlyTextField(
                      controller: TextEditingController(text: provider.hostName),
                      onChanged: (String _) => provider.setHostName = _,
                      label: LocaleKeys.host_name.tr(),
                      hint: LocaleKeys.who_hosting_it.tr(),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    VerticalSpace(20.h),
                    Text(
                      LocaleKeys.thumbnail.tr(),
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4.h),
                    ClipRRect(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(8.r), topLeft: Radius.circular(8.r)),
                      child: Center(
                        child: DottedBorder(
                          borderType: BorderType.Rect,
                          dashPattern: const [10, 6],
                          color: EventlyAppTheme.kTextDarkPurple,
                          strokeWidth: 3.h,
                          child: provider.thumbnail != null
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.file(provider.thumbnail!),
                                    GestureDetector(onTap: () => provider.pickThumbnail(), child: SvgPicture.asset(SVGUtils.kSvgUpload)),
                                  ],
                                )
                              : GestureDetector(
                                  onTap: () => provider.pickThumbnail(),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 20.w),
                                    child: Column(
                                      children: [
                                        Text(
                                          LocaleKeys.tap_select.tr(),
                                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: EventlyAppTheme.kTextDarkPurple),
                                        ),
                                        VerticalSpace(10.h),
                                        SvgPicture.asset(SVGUtils.kSvgUpload),
                                        VerticalSpace(10.h),
                                        Text(
                                          LocaleKeys.mb_limit.tr(),
                                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: EventlyAppTheme.kTextDarkPurple),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const VerticalSpace(80),
                    BottomButtons(
                      onPressContinue: () {},
                      onPressSaveDraft: () {},
                      isContinueEnable: provider.isOverviewEnable,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void validateAndUpdateDescription({required bool moveNextPage}) {}
}
