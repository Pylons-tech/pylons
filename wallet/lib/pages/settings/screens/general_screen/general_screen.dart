import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart' as button;
import 'package:pylons_wallet/pages/home/collection_screen/collection_view_model.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/pages/settings/common/settings_divider.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/general_screen_localization_view_model.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/route_util.dart';

TextStyle kGeneralLabelText = TextStyle(fontSize: 28.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w800);
TextStyle kGeneralOptionsText = TextStyle(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w500);

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({Key? key}) : super(key: key);

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  GeneralScreenLocalizationViewModel get _languageViewModel => GetIt.I.get();

  HomeProvider get _homeProvider => GetIt.I.get();

  CollectionViewModel get _collectionProvider => GetIt.I.get();

  Repository get repository => GetIt.I.get();

  @override
  void initState() {
    super.initState();

    repository.logUserJourney(screenName: AnalyticsScreenEvents.general);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 37.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top + 20.h,
            ),
            SizedBox(
              height: 33.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.kUserInputTextColor,
                  )),
            ),
            SizedBox(
              height: 33.h,
            ),
            Text(
              "general".tr(),
              style: kGeneralLabelText,
            ),
            SizedBox(
              height: 20.h,
            ),
            NotificationsListItem(
              title: "notifications".tr(),
            ),
            GeneralForwardItem(
              title: "payment".tr(),
              onPressed: () {
                Navigator.of(context).pushNamed(RouteUtil.ROUTE_PAYMENT);
              },
            ),
            GeneralForwardItem(
              title: "security".tr(),
              onPressed: () {
                Navigator.of(context).pushNamed(RouteUtil.ROUTE_SECURITY);
              },
            ),
            GeneralForwardItem(
              title: "transactions".tr(),
              onPressed: () {
                Navigator.of(context).pushNamed(RouteUtil.ROUTE_FAILURE);
              },
            ),
            GeneralForwardItem(
              title: "language".tr(),
              onPressed: () {
                _languageViewModel.setCurrentLanguage(context);
                _modalBottomSheetMenu(_languageViewModel);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _modalBottomSheetMenu(GeneralScreenLocalizationViewModel value) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          return ChangeNotifierProvider.value(
              value: value,
              builder: (context, child) {
                return Consumer<GeneralScreenLocalizationViewModel>(builder: (context, model, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 15.0.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                        child: Text(
                          "select_language".tr(),
                          style: TextStyle(color: AppColors.kTextBlackColor, fontSize: 19.0.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                languagesSupported[index]['name']! as String,
                                style: TextStyle(fontSize: 16.sp),
                              ).tr(),
                              trailing: languagesSupported[index]['selected']! as bool
                                  ? Icon(
                                      Icons.check,
                                      color: AppColors.kDarkGreen,
                                    )
                                  : const SizedBox(),
                              onTap: () {
                                model.switchLanguage(index, languagesSupported[index]['name']! as String);
                              },
                            );
                          },
                          itemCount: languagesSupported.length,
                        ),
                      ),
                      SizedBox(
                        height: 15.0.h,
                      ),
                      InkWell(
                        onTap: () {
                          model.applyLocal(context);
                          _homeProvider.refreshScreen();
                          _collectionProvider.refreshScreen();
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: CustomPaint(
                            painter: button.BoxShadowPainter(cuttingHeight: 10.h),
                            child: ClipPath(
                              clipper: button.MnemonicClipper(cuttingHeight: 10.h),
                              child: Container(
                                color: AppColors.kBlue,
                                height: 40.h,
                                width: 250.0.w,
                                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                                child: Center(
                                    child: Text(
                                  "apply".tr(),
                                  style: TextStyle(color: AppColors.kWhite, fontSize: 16.sp, fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0.h,
                      ),
                    ],
                  );
                });
              });
        });
  }
}

class GeneralForwardItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const GeneralForwardItem({required this.title, Key? key, required this.onPressed}) : super(key: key);

  GeneralScreenLocalizationViewModel get _languageViewModel => GetIt.I.get<GeneralScreenLocalizationViewModel>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: 30.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: kGeneralOptionsText,
                ),
                if (title == "language".tr())
                  ChangeNotifierProvider.value(
                      value: _languageViewModel,
                      builder: (context, child) {
                        return Consumer<GeneralScreenLocalizationViewModel>(builder: (context, model, child) {
                          return Text(model.getLanguageName(context),
                              style: TextStyle(fontSize: 15.sp, fontFamily: kUniversalFontFamily, color: AppColors.kUserInputTextColor, fontWeight: FontWeight.w500));
                        });
                      })
                else if (title == "invite_others".tr())
                  const SizedBox()
                else
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: AppColors.kForwardIconColor,
                  )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        const SettingsDivider()
      ],
    );
  }
}

class NotificationsListItem extends StatefulWidget {
  final String title;

  const NotificationsListItem({Key? key, required this.title}) : super(key: key);

  @override
  State<NotificationsListItem> createState() => _NotificationsListItemState();
}

class _NotificationsListItemState extends State<NotificationsListItem> {
  bool isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();

    final notificationPreferenceEither = GetIt.I.get<Repository>().getNotificationsPreference();

    isNotificationEnabled = notificationPreferenceEither.getOrElse(() => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        SizedBox(
          height: 30.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: kGeneralOptionsText,
              ),
              CupertinoSwitch(
                trackColor: AppColors.kSwitchInactiveColor,
                value: isNotificationEnabled,
                onChanged: (value) {
                  GetIt.I.get<Repository>().saveNotificationsPreference(notificationStatus: value);
                  setState(() {
                    isNotificationEnabled = value;
                  });
                },
                activeColor: AppColors.kSwitchActiveColor,
              )
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        const SettingsDivider()
      ],
    );
  }
}
