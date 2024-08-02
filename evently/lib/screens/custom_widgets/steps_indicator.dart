import 'package:evently/utils/evently_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:steps_indicator/steps_indicator.dart';

class MyStepsIndicator extends StatelessWidget {
  final ValueNotifier<int> currentStep;

  const MyStepsIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentStep,
        builder: (_, int value, __) {
          return StepsIndicator(
            selectedStep: currentStep.value,
            nbSteps: 4,
            lineLength: 0.68.sw / 4,
            doneLineColor: EventlyAppTheme.kBlue,
            undoneLineColor: EventlyAppTheme.kGery03,
            doneLineThickness: 1.5,
            undoneLineThickness: 1.5,
            unselectedStepColorIn: EventlyAppTheme.kGery03,
            unselectedStepColorOut: EventlyAppTheme.kGery03,
            doneStepColor: EventlyAppTheme.kBlue,
            selectedStepColorIn: EventlyAppTheme.kBlue,
            selectedStepColorOut: EventlyAppTheme.kBlue,
            enableLineAnimation: true,
            enableStepAnimation: true,
            lineLengthCustomStep: const [],
            doneStepWidget: Container(width: 10.w, height: 10.h, decoration: const BoxDecoration(color: EventlyAppTheme.kBlue)),
            unselectedStepWidget: Container(width: 10.w, height: 10.h, decoration: const BoxDecoration(color: EventlyAppTheme.kGery03)),
            selectedStepWidget: Container(width: 15.w, height: 15.h, decoration: const BoxDecoration(color: EventlyAppTheme.kBlue)),
          );
        });
  }
}
