import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepLabels extends StatelessWidget {
  final ValueNotifier<int> currentStep;
  final ValueNotifier<int> currentPage;

  const StepLabels({
    Key? key,
    required this.currentPage,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
      child: Row(
        children: List.generate(stepLabels.length, (index) {
          return SizedBox(
            width: (0.8.sw / stepLabels.length),
            child: ValueListenableBuilder(
              valueListenable: currentPage,
              builder: (_, int currentPage, __) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stepLabels[index].toString().tr(),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 12.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: currentStep.value >= index
                              ? EaselAppTheme.kDarkGreen
                              : EaselAppTheme.kGrey,
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
