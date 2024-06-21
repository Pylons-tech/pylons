import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/viewmodels/create_event_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PageAppBar extends StatelessWidget {
  const PageAppBar({
    super.key,
    required this.onPressBack,
  });

  final VoidCallback onPressBack;

  @override
  Widget build(BuildContext context) {
    final createEventViewModel = context.watch<CreateEventViewModel>();
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: ValueListenableBuilder(
              valueListenable: createEventViewModel.currentPage,
              builder: (_, int currentPage, __) => Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    onPressed: onPressBack,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: EventlyAppTheme.kGrey02,
                    ),
                  )),
            )),
        ValueListenableBuilder(
          valueListenable: createEventViewModel.currentPage,
          builder: (_, int currentPage, __) {
            return Text(
              createEventViewModel.pageTitles[createEventViewModel.currentPage.value],
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700, color: EventlyAppTheme.kTextDarkBlue),
            );
          },
        ),
      ],
    );
  }
}
