import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_app_drawer.dart';
import 'package:pylons_wallet/pages/discover/discover_screen.dart';
import 'package:pylons_wallet/pages/gallery/gallery_screen.dart';
import 'package:pylons_wallet/pages/home/home_screen.dart';
import 'package:pylons_wallet/pages/marketplace/marketplace_screen.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);
  final _title = 'pylons_home'.tr();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: const DashboardWidget(),
    );
  }
}

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    //_pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _selectedIndex = page;
    });
  }

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    DiscoverScreen(),
    MarketplaceScreen(),
    GalleryScreen()
  ];

  static const TextStyle optionStyle = TextStyle(
      fontSize: 12, color: Colors.indigo, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        //appBar: PylonsAppBar(),
        //body: SafeArea(
        //  child: _pages[_selectedIndex],
        //),
        body: PageView(
            onPageChanged: onPageChanged,
            controller: _pageController,
            children: _pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.black12,
          showUnselectedLabels: true,
          selectedLabelStyle: optionStyle,
          unselectedLabelStyle: optionStyle,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: const ImageIcon(
                  AssetImage('assets/icons/home.png'),
                  size: 24,
                ),
                label: "home".tr()),
            BottomNavigationBarItem(
                icon: const ImageIcon(
                  AssetImage('assets/icons/discover.png'),
                  size: 24,
                ),
                label: "discover".tr()),
            BottomNavigationBarItem(
                icon: const ImageIcon(
                  AssetImage('assets/icons/market.png'),
                  size: 24,
                ),
                label: "market_place".tr()),
            BottomNavigationBarItem(
                icon: const ImageIcon(
                  AssetImage('assets/icons/gallery.png'),
                  size: 24,
                ),
                label: "gallery".tr()),
          ],
        ),
        drawer: const PylonsAppDrawer(),
      ),
    );
  }
}
