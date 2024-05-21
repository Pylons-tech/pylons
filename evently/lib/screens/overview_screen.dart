import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OverViewScreen extends StatefulWidget {
  const OverViewScreen({super.key});

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
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
              Navigator.of(context).pop();
            }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventlyTextField(
                    controller: TextEditingController(text: provider.eventName)
                      ..selection = TextSelection.fromPosition(
                        TextPosition(offset: provider.eventName.length),
                      ),
                    onChanged: (_) => provider.setEventName = _,
                    label: LocaleKeys.event_name.tr(),
                    hint: LocaleKeys.what_your_event_called.tr(),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  VerticalSpace(20.h),
                  EventlyTextField(
                    controller: TextEditingController(text: provider.hostName)
                      ..selection = TextSelection.fromPosition(
                        TextPosition(offset: provider.hostName.length),
                      ),
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
                        child: provider.thumbnail!.isNotEmpty
                            ? SizedBox(
                                height: 180,
                                width: double.infinity,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      imageUrl: provider.thumbnail!,
                                      errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
                                      progressIndicatorBuilder: (context, _, progress) {
                                        return Shimmer(color: EventlyAppTheme.kGrey04, child: const SizedBox.expand());
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () => provider.pickThumbnail(),
                                      child: SvgPicture.asset(
                                        SVGUtils.kSvgUpload,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () => provider.pickThumbnail(),
                                child: Container(
                                  width: double.infinity,
                                  height: 180,
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
                    onPressContinue: () {
                      provider.saveAsDraft(
                        onCompleted: () => {},
                        uploadStep: UploadStep.overView,
                      );
                      createEventViewModel.nextPage();
                    },
                    onPressSaveDraft: () {
                      final navigator = Navigator.of(context);
                      provider.saveAsDraft(
                        onCompleted: () => navigator.popUntil((route) => route.settings.name == RouteUtil.kRouteEventHub),
                        uploadStep: UploadStep.overView,
                      );
                    },
                    isContinueEnable: provider.isOverviewEnable,
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  void validateAndUpdateDescription({required bool moveNextPage}) {}
}
