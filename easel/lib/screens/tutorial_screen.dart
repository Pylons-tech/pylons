import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import '../utils/constants.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  TutorialScreenState createState() => TutorialScreenState();
}

class TutorialScreenState extends State<TutorialScreen> {
  BottomDrawerController myBottomDrawerController = BottomDrawerController();
  final tutorialProvider = GetIt.I.get<TutorialScreenViewModel>();

  late List<Widget> slides;

  List<Widget> indicator() => List<Widget>.generate(
        slides.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: currentPage.round() == index ? 16.w : 12.h,
          width: currentPage.round() == index ? 18.w : 12.h,
          decoration: BoxDecoration(
            color: currentPage.round() == index ? getColorPerPage(index) : EaselAppTheme.kLightGrey,
          ),
        ),
      );

  double currentPage = 0.0;
  final _pageViewController = PageController();

  Color getColorPerPage(int index) {
    switch (index) {
      case 0:
        return EaselAppTheme.kDarkGreen;
      case 1:
        return EaselAppTheme.kYellow;
      case 2:
        return EaselAppTheme.kLightRed;
      default:
        return EaselAppTheme.kLightGrey;
    }
  }

  @override
  void initState() {
    super.initState();

    tutorialProvider.setLog();
    
    myBottomDrawerController = BottomDrawerController();
    slides = kTutorialItems
        .map((item) => Column(
              children: <Widget>[
                SizedBox(height: 0.1.sh),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.22.sw),
                    child: Image.asset(
                      item[kImageTutorial],
                      height: 10.h,
                      width: 40,
                      fit: BoxFit.fill,
                    )),
                SizedBox(height: 0.1.sh),
                Text(item[kHeaderTutorial], style: TextStyle(fontSize: isTablet ? 16.sp : 18.sp, fontWeight: FontWeight.w800, color: EaselAppTheme.kDartGrey), textAlign: TextAlign.center),
                SizedBox(height: 15.h),
                SizedBox(width: 0.63.sw, child: Text(item[kDescriptionTutorial], style: TextStyle(color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w400), textAlign: TextAlign.center)),
              ],
            ))
        .toList();
    _pageViewController.addListener(() {
      if (doMoveForwardToMessageScreen()) {
        moveForwardToEaselMessage();
        return;
      }
      setState(() {
        currentPage = _pageViewController.page!;
      });
    });
  }

  bool doMoveForwardToMessageScreen() => currentPage == 2 && _pageViewController.position.userScrollDirection == ScrollDirection.reverse && !tutorialProvider.isForwarding;

  @override
  Widget build(BuildContext context) {
    slides = kTutorialItems
        .map((item) => Column(
              children: <Widget>[
                SizedBox(height: 0.2.sh),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.22.sw),
                    child: Image.asset(
                      item[kImageTutorial],
                      height: isTablet ? 140.w : 200.w,
                      width: isTablet ? 140.w : 200.w,
                      fit: BoxFit.fill,
                    )),
                SizedBox(height: 0.15.sh),
                Text(item[kHeaderTutorial], style: TextStyle(fontSize: isTablet ? 16.sp : 18.sp, fontWeight: FontWeight.w800, color: EaselAppTheme.kDartGrey), textAlign: TextAlign.center),
                SizedBox(height: 15.h),
                SizedBox(width: 0.63.sw, child: Text(item[kDescriptionTutorial], style: TextStyle(color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w400), textAlign: TextAlign.center)),
              ],
            ))
        .toList();
    return Scaffold(
      backgroundColor: EaselAppTheme.kWhite03,
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageViewController,
            physics: const BouncingScrollPhysics(),
            itemCount: slides.length,
            itemBuilder: (BuildContext context, int index) {
              return slides[index];
            },
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: isTablet ? 85.h : 120.h),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: indicator(),
                ),
              )),

          // )
        ],
      ),
    );
  }

  bool isLastPage() => currentPage.round() == slides.length - 1;

  Widget buildBottomDrawer(BuildContext context) {
    return BottomDrawer(
      header: Container(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: const BoxDecoration(
                      color: EaselAppTheme.kLightRed,
                      shape: BoxShape.rectangle,
                    )),
                SizedBox(width: 24.w),
                SizedBox(
                  width: 0.7.sw,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("pylons_app_desc_1".tr(), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: Colors.black)),
                      SizedBox(height: 8.h),
                      Text("discover_new_apps_adventures".tr(), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kLightGrey))
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: const BoxDecoration(
                      color: EaselAppTheme.kYellow,
                      shape: BoxShape.rectangle,
                    )),
                SizedBox(width: 24.w),
                SizedBox(
                  width: 0.7.sw,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("app_desc_2".tr(), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: Colors.black)),
                      SizedBox(height: 8.h),
                      Text("app_needed_desc_two".tr(), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kLightGrey))
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: const BoxDecoration(
                      color: EaselAppTheme.kDarkGreen,
                      shape: BoxShape.rectangle,
                    )),
                SizedBox(width: 24.w),
                SizedBox(
                  width: 0.7.sw,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("app_needed_desc_three".tr(), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: Colors.black)),
                      SizedBox(height: 8.h),
                      Text("why_app_needed_summary_three".tr(), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: EaselAppTheme.kLightGrey))
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h),
            ScreenResponsive(
              mobileScreen: (context) => Align(
                alignment: Alignment.center,
                child: PylonsButton(
                  onPressed: () async {
                    await onDownloadNowPressed(context);
                  },
                  btnText: 'download_pylons_app'.tr(),
                  color: EaselAppTheme.kBlue,
                ),
              ),
              tabletScreen: (BuildContext context) => Center(
                child: SizedBox(
                  width: 0.5.sw,
                  child: PylonsButton(
                    onPressed: () async {
                      await onDownloadNowPressed(context);
                    },
                    btnText: 'download_pylons_app'.tr(),
                    color: EaselAppTheme.kBlue,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      headerHeight: 0,
      drawerHeight: 0.5.sh,
      color: EaselAppTheme.kLightGrey02,
      controller: myBottomDrawerController,
    );
  }

  Future<void> onDownloadNowPressed(BuildContext context) async {
    final scaffoldState = ScaffoldMessenger.of(context);
    final appAlreadyInstalled = await PylonsWallet.instance.exists();
    if (!appAlreadyInstalled) {
      PylonsWallet.instance.goToInstall();
    } else {
      scaffoldState.show(message: "pylons_already_installed".tr());
    }
  }

  void moveForwardToEaselMessage() async {
    tutorialProvider.forwarding();
    await navigatorKey.currentState!.pushReplacementNamed(RouteUtil.kRouteWelcomeEasel);
    tutorialProvider.forwarding();
  }
}

class TutorialScreenViewModel extends ChangeNotifier {
  bool isForwarding = false;
  final Repository repository;
  TutorialScreenViewModel({required this.repository});

  void forwarding() {
    isForwarding = !isForwarding;
    notifyListeners();
  }

  void setLog() {
    repository.logUserJourney(screenName: AnalyticsScreenEvents.tutorialScreen);
  }
}
