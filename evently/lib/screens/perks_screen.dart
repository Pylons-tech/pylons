import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/screens/custom_widgets/step_labels.dart';
import 'package:evently/screens/custom_widgets/steps_indicator.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/utils/space_utils.dart';
import 'package:evently/viewmodels/create_event_viewmodel.dart';
import 'package:evently/widgets/clipped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PerksScreen extends StatefulWidget {
  const PerksScreen({super.key});

  @override
  State<PerksScreen> createState() => _PerksScreenState();
}

class _PerksScreenState extends State<PerksScreen> {

  final _formKey = GlobalKey<FormState>();

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
