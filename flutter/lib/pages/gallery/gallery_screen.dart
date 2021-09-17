import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_app_bar.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/pylons_white_button.dart';
import 'package:pylons_wallet/pages/gallery/gallery_tab_collection.dart';

class GalleryScreenWidget extends StatefulWidget {
  const GalleryScreenWidget({Key? key}) : super(key: key);

  @override
  State<GalleryScreenWidget> createState() => _GalleryScreenWidgetState();
}

class _GalleryScreenWidgetState extends State<GalleryScreenWidget> with SingleTickerProviderStateMixin {
  final double bannerSize = 135;
  int tabIndex = 0;
  late TabController _tabController;

  final List<Tab> myTabs = <Tab>[
    new Tab(text: 'Collection'),
    new Tab(text: 'Liked'),
  ];

  static const List<Widget> _pages = <Widget>[
    GalleryTabCollectionWidget(),
    Text('Liked')
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_tabSelect);
  }

  void _tabSelect() {
    setState(() {
      tabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(16.0),
        child: new Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                alignment: Alignment.center,
                color: Colors.black12,
                width: MediaQuery.of(context).size.width,
                height: bannerSize,
                child: ListTile(
                    minLeadingWidth : 10,
                    leading: ImageIcon(
                        AssetImage('assets/images/icon/add_btn.png'),
                        size: 20,
                        color: Color(0xFF616161)
                    ),
                    title: Text('Add an Image', style: TextStyle(color: Colors.white),)
                  )
              ),
            ),
            Positioned(
              top: bannerSize - 25,
              left: 15,
              right: 15,
              child: Card(
                elevation: 8,
                color: Colors.white,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Container(
                  width: MediaQuery.of(context).size.width * .90,
                  height: 170,
                  child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const ListTile(
                            minLeadingWidth : 10,
                            leading: CircleAvatar(
                              child: FlutterLogo(size: 28.0),
                            ),
                            title: Text(
                                'Linda',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF201D1D),
                                )
                            ),
                            subtitle: Text('Media Artist (3d, Motiongraphics, Collecting NFT)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF616161)
                            )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 70),
                              Text('followers: 23'),
                              SizedBox(width: 60),
                              Text('following: 20')
                            ],
                          ),

                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              PylonsBlueButton(onTap: (){}, text: '       Follow       '),
                              OutlinedButton(
                                onPressed: () {},
                                child: ImageIcon(
                                    AssetImage('assets/images/icon/chevron-down.png'),
                                    size: 20,
                                    color: Color(0xFF616161)
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5), // <-- Radius
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: bannerSize + 170,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // some other widgets
                    Container(
                        color: Colors.white,
                        child: TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          labelColor: Colors.grey[700],
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Color(0xFF1212C4),
                          tabs: myTabs,
                          labelPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        )
                    ),
                    Container(
                      child: _pages[tabIndex]
                    )
                  ],
                ),
              ),

            )


          ],
        )
    );
  }
}
