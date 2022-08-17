import 'dart:developer';

import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:steps_indicator/steps_indicator.dart';

class MyStepsIndicator extends StatelessWidget {
  final ValueNotifier<int> currentStep;

  const MyStepsIndicator({
    Key? key,
    required this.currentStep,

  }) : super(key: key);

  final int _numSteps = 3;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentStep,
      builder: (_, int value, __) {
        return StepsIndicator(
          selectedStep: currentStep.value,
          nbSteps: _numSteps,
          lineLength: 0.68.sw / _numSteps,
          doneLineColor: EaselAppTheme.kBlue,
          undoneLineColor: EaselAppTheme.kLightGrey,
          doneLineThickness: 1.5,
          undoneLineThickness: 1.5,
          unselectedStepColorIn: EaselAppTheme.kLightGrey,
          unselectedStepColorOut: EaselAppTheme.kLightGrey,
          doneStepColor: EaselAppTheme.kBlue,
          selectedStepColorIn: EaselAppTheme.kBlue,
          selectedStepColorOut: EaselAppTheme.kBlue,
          enableLineAnimation: true,
          enableStepAnimation: true,
          lineLengthCustomStep: const [],
          doneStepWidget: Container(width: 10.w, height: 10.h, decoration: const BoxDecoration(color: EaselAppTheme.kBlue)),
          unselectedStepWidget: Container(width: 10.w, height: 10.h, decoration: const BoxDecoration(color: EaselAppTheme.kLightGrey)),
          selectedStepWidget: Container(width: 15.w, height: 15.h, decoration: const BoxDecoration(color: EaselAppTheme.kBlue)),
        );
      }
    );
  }
}
