import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_app_bar.dart';
import 'package:pylons_wallet/components/pylons_app_drawer.dart';
import 'package:pylons_wallet/components/pylons_dashboard_dropdown.dart';
import 'package:pylons_wallet/components/pylons_history_card.dart';
import 'package:pylons_wallet/pages/dashboard/dashboard_assets.dart';
import 'package:pylons_wallet/pages/discover/discover_screen.dart';
import 'package:pylons_wallet/pages/gallery/gallery_screen.dart';
import 'package:pylons_wallet/pages/home/home_screen.dart';
import 'package:pylons_wallet/pages/marketplace/marketplace_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);
  static const String _title = 'Pylons Home';
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: DashboardWidget(),
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
PageController _pageController = PageController(initialPage: 0);

@override
void initState(){
  super.initState();
  //_pageController = PageController(initialPage: _selectedIndex);
}

@override
void dispose(){
  _pageController.dispose();
  super.dispose();
}

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
    _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
  });
}

void onPageChanged(int page) {
  setState((){
    _selectedIndex = page;
  });
}


static const List<Widget> _pages = <Widget>[
  HomeScreenWidget(),
  DiscoverScreenWidget(),
  MarketplaceScreenWidget(),
  GalleryScreenWidget()
];

static const TextStyle optionStyle = TextStyle(fontSize: 12, color: Colors.indigo, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: PylonsAppBar(),
      //body: SafeArea(
      //  child: _pages[_selectedIndex],
      //),
      body: PageView(
        children: _pages,
        onPageChanged: onPageChanged,
        controller: _pageController
      ),

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
                AssetImage('assets/images/icon/home.png'),
                size: 24,
              ),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('assets/images/icon/discover.png'),
                size: 24,
              ),
              label: 'Discover'
          ),
          BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('assets/images/icon/marketplace.png'),
                size: 24,
              ),
              label: 'MarketPlace'
          ),
          BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('assets/images/icon/gallery.png'),
                size: 24,
              ),
              label: 'Gallery'
          ),
        ],
      ),
      drawer: PylonsAppDrawer(),
    );
  }
}
