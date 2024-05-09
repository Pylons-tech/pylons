import 'package:easy_localization/easy_localization.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepLabels extends StatelessWidget {
  final ValueNotifier<int> currentStep;
  final ValueNotifier<int> currentPage;

  const StepLabels({
    super.key,
    required this.currentPage,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
      child: Row(
        children: List.generate(stepLabels.length, (index) {
          return SizedBox(
            width: 0.8.sw / stepLabels.length,
            child: ValueListenableBuilder(
              valueListenable: currentPage,
              builder: (_, int currentPage, __) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stepLabels[index].tr(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 8.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          color: currentStep.value >= index ? EventlyAppTheme.kBlue : EventlyAppTheme.kGery03,
                        ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
