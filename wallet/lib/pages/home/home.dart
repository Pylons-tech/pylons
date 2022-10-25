import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/ipc/ipc_engine.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_view_model.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/screen_responsive.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  WalletsStore get walletsStore => GetIt.I.get();

  HomeProvider get homeProvider => GetIt.I.get();

  CollectionViewModel get collectionViewModel => GetIt.I.get();

  @override
  void initState() {
    super.initState();
    homeProvider.logAnalyticsEvent();
    _tabController = TabController(vsync: this, length: homeProvider.pages.length);
    getInitialLink();
  }

  Future<void> getInitialLink() async {
    await Future.delayed(const Duration(seconds: 2));

    final String link = walletsStore.getInitialLink().getOrElse(() => '');
    if (link.isNotEmpty) {
      await GetIt.I.get<IPCEngine>().handleLinksBasedOnUri(link);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final int tabLen;
    if (kDebugMode) {
      tabLen = 3;
    } else {
      tabLen = 2;
    }

    return FocusDetector(
      onFocusGained: () {
        homeProvider.shouldShowBadgeOrNot();
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeProvider>.value(
            value: homeProvider,
          ),
          ChangeNotifierProvider<CollectionViewModel>.value(
            value: collectionViewModel,
          ),
        ],
        child: Consumer<HomeProvider>(builder: (context, provider, _) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: provider.isBannerDark() ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            child: RotatedBox(
              quarterTurns: 0,
              child: ColoredBox(
                color: AppColors.kMainBG,
                child: WillPopScope(
                  onWillPop: () async => false,
                  child: DefaultTabController(
                    length: tabLen,
                    child: Scaffold(
                      backgroundColor: AppColors.kMainBG,
                      appBar: buildAppBar(context, provider),
                      body: provider.pages[provider.selectedIndex],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context, HomeProvider provider) {
    return PreferredSize(
      preferredSize: Size.fromHeight(isTablet ? 0.4.sh : 0.2.sh + 115.h),
      child: ScreenResponsive(
        mobileScreen: (BuildContext context) => buildMobileAppBar(provider),
        tabletScreen: (BuildContext context) => buildTabletAppBar(provider),
      ),
    );
  }

  Column buildTabletAppBar(HomeProvider provider) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 0.2.sh + 35.h,
            ),
            UserBannerWidget(height: 0.2.sh),
            Positioned(
              top: 0.035.sh,
              left: 0.93.sw,
              child: UserBannerPickerWidget(),
            ),
            Positioned(
              top: 0.04.sh,
              left: 0.86.sw,
              child: GestureDetector(
                onTap: () async {
                  Navigator.of(context).pushNamed(RouteUtil.ROUTE_MESSAGE);
                },
                behavior: HitTestBehavior.translucent,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      SVGUtil.MESSAGE_ENVELOPE,
                      height: 15.h,
                      width: 15.w,
                      fit: BoxFit.fill,
                      color: provider.isBannerDark() ? Colors.white : Colors.black,
                    ),
                    if (provider.showBadge) Positioned(right: 0.w, top: 0.h, child: buildBadge()),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0.035.sh,
              left: 0.025.sw,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteUtil.ROUTE_SETTINGS);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: SvgPicture.asset(
                    SVGUtil.SORT,
                    color: provider.isBannerDark() ? Colors.white : Colors.black,
                    height: 20.h,
                    width: 20.w,
                  )),
            ),
            Positioned(
              top: 0.2.sh - 30.r,
              left: 0.5.sw - 30.r,
              child: CircleAvatar(
                backgroundColor: AppColors.kMainBG,
                radius: 34.r,
                child: UserAvatarWidget(radius: 30.r),
              ),
            ),
            Positioned(
              top: 0.2.sh + 20.r,
              left: 0.5.sw + 20.r,
              child: const UserAvatarPickerWidget(),
            )
          ],
        ),
        Text(
          walletsStore.getWallets().value.last.name,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20.sp),
          textAlign: TextAlign.center,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "wallet_address_arg".tr(args: [walletsStore.getWallets().value.last.publicAddress]),
            style: TextStyle(color: Colors.black, fontSize: 9.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(width: 5.w),
          GestureDetector(
            onTap: () async {
              final publicAddress = GetIt.I.get<WalletsStore>().getWallets().value.last.publicAddress;

              await Clipboard.setData(ClipboardData(text: publicAddress));
              "copied_to_clipboard".tr().show();
            },
            child: SvgPicture.asset(SVGUtil.WALLET_COPY, height: 10.h, width: 10.w, fit: BoxFit.scaleDown),
          ),
        ]),
        SizedBox(height: 20.h),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          WalletTab(
            tabName: provider.tabs[0],
            index: 0,
          ),
          WalletTab(
            tabName: provider.tabs[1],
            index: 1,
          )
        ]),
        SizedBox(height: 5.h),
      ],
    );
  }

  Container buildBadge() {
    return Container(
      height: isTablet ? 6.w : 8.w,
      width: isTablet ? 6.w : 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.kDarkRed,
      ),
    );
  }

  Column buildMobileAppBar(HomeProvider provider) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 0.2.sh + 35.h,
            ),
            UserBannerWidget(height: 0.2.sh),
            Positioned(
              top: 0.06.sh,
              right: 0.02.sw,
              child: UserBannerPickerWidget(),
            ),
            Positioned(
              top: 0.062.sh,
              right: 0.12.sw,
              child: InkResponse(
                onTap: () async {
                  Navigator.of(context).pushNamed(RouteUtil.ROUTE_MESSAGE);
                },
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      SVGUtil.MESSAGE_ENVELOPE,
                      height: 20.h,
                      width: 20.w,
                      fit: BoxFit.fill,
                      color: provider.isBannerDark() ? Colors.white : Colors.black,
                    ),
                    if (provider.showBadge) Positioned(right: 0.w, top: 0.h, child: buildBadge()),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0.06.sh,
              left: 0.09.sw,
              child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteUtil.ROUTE_SETTINGS);
                  },
                  child: SvgPicture.asset(
                    SVGUtil.SORT,
                    color: provider.isBannerDark() ? Colors.white : Colors.black,
                    height: 20.h,
                    width: 20.w,
                  )),
            ),
            Positioned(
              top: 0.2.sh - 30.r,
              left: 0.5.sw - 30.r,
              child: CircleAvatar(
                backgroundColor: AppColors.kMainBG,
                radius: 34.r,
                child: UserAvatarWidget(radius: 30.r),
              ),
            ),
            Positioned(
              top: 0.2.sh + 20.r,
              left: 0.5.sw + 20.r,
              child: const UserAvatarPickerWidget(),
            )
          ],
        ),
        Text(
          walletsStore.getWallets().value.last.name,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20.sp),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5.h),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "wallet_address_arg".tr(args: [walletsStore.getWallets().value.last.publicAddress]),
            style: TextStyle(color: Colors.black, fontSize: 9.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(width: 5.w),
          GestureDetector(
            onTap: () async {
              final publicAddress = GetIt.I.get<WalletsStore>().getWallets().value.last.publicAddress;
              await Clipboard.setData(ClipboardData(text: publicAddress));
              "copied_to_clipboard".tr().show();
            },
            child: SvgPicture.asset(SVGUtil.WALLET_COPY, height: 15.h, width: 15.w, fit: BoxFit.scaleDown),
          ),
        ]),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WalletTab(
              tabName: provider.tabs[0],
              index: 0,
            ),
            WalletTab(
              tabName: provider.tabs[1],
              index: 1,
            )
          ],
        ),
        SizedBox(height: 5.h),
      ],
    );
  }
}

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const pointMode = ui.PointMode.polygon;
    final points = [const Offset(0, 10), const Offset(100, 10), const Offset(110, -2)];
    final paint = Paint()
      ..color = AppColors.kDarkRed
      ..strokeWidth = 3;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class WalletTab extends StatelessWidget {
  final int index;
  final String tabName;

  const WalletTab({Key? key, required this.tabName, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.read<HomeProvider>();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => homeProvider.changeTabs(index),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: SizedBox(
          height: 30.h,
          width: 100.w,
          child: Stack(
            children: [
              Center(
                child: Text(
                  tabName.tr(),
                  style: TextStyle(
                    color: index == homeProvider.selectedIndex ? AppColors.kDarkRed : AppColors.kBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Visibility(
                visible: index == homeProvider.selectedIndex,
                child: Positioned.fill(
                  child: Align(
                    alignment: isTablet ? Alignment.bottomCenter : Alignment.bottomLeft,
                    child: CustomPaint(size: Size(100, 10.h), painter: DiagonalLinePainter()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
