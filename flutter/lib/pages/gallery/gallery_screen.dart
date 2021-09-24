import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/follow_card.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/pages/account/account.dart';
import 'package:pylons_wallet/pages/edit_profile/edit_profile_screen.dart';
import 'package:pylons_wallet/pages/gallery/add_artwork.dart';
import 'package:pylons_wallet/pages/gallery/gallery_tab_collection.dart';
import 'package:pylons_wallet/pages/gallery/gallery_tab_like.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with SingleTickerProviderStateMixin {
  final double bannerSize = 135;
  int tabIndex = 0;
  late TabController _tabController;
  bool isExpanded = false;

  final List<Widget> myTabs = <Widget>[
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text('collection'.tr()),
    ),
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text('liked'.tr()),
    ),
  ];

  static const List<Widget> _pages = <Widget>[
    GalleryTabCollectionWidget(),
    GalleryTabLikeWidget()
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

  void setExandMode() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  minLeadingWidth: 10,
                  leading: const ImageIcon(
                      AssetImage('assets/images/icon/add_btn.png'),
                      size: 20,
                      color: Color(0xFF616161)),
                  title: Text(
                    'add_an_image'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ))),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                color: Colors.white,
                child: TabBar(
                  indicatorPadding: const EdgeInsets.only(left: 10, right: 10),
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: const Color(0xFF1212C4),
                  unselectedLabelColor: Colors.grey[700],
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: const Color(0xFF1212C4),
                  tabs: myTabs,
                  labelPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                )),
            Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddArtworkWidget();
                        });
                  },
                  icon: const Icon(Icons.add),
                ))
          ],
        ),
        Positioned(
          top: bannerSize + 200,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // some other widgets

                Container(child: _pages[tabIndex])
              ],
            ),
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
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * .90,
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    minLeadingWidth: 10,
                    leading: const CircleAvatar(
                      radius: 30,
                      child: FlutterLogo(size: 28.0),
                    ),
                    title: const Text('Linda',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF201D1D),
                        )),
                    subtitle: const Text(
                        'Media Artist (3D, Motiongraphics, Collecting NFT)',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF616161))),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AccountScreenWidget()));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 70),
                      Text('${'followers'.tr()}: 23'),
                      const SizedBox(width: 60),
                      Text('${'followings'.tr().toLowerCase()}: 20')
                    ],
                  ),
                  const VerticalSpace(10),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 30,
                          width: 138,
                          child:
                              PylonsBlueButton(onTap: () {}, text: 'follow'.tr())),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: OutlinedButton(
                          onPressed: () {
                            setExandMode();
                          },
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            primary: Colors.white,
                            padding: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // <-- Radius
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: const Color(0xFF616161),
                            ),
                          ),
                        ),
                      ),
                         ElevatedButton(
                            onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                                side: const BorderSide(color: Color(0xffCACACA),)
                              )
                            ),
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                      "Edit Profile",
                                      style: const TextStyle(fontSize: 15, color: Color(0xff616161))),
                                ],
                              ),
                            ),
                          ),
                          
                      //),
                      // SizedBox(
                      //   height: 30,
                      //   width: 30,
                      //   child: OutlinedButton(
                      //     onPressed: () {
                      //       this.setExandMode();
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       alignment:Alignment.center,
                      //       primary: Colors.white,
                      //       padding: EdgeInsets.all(0),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(5), // <-- Radius
                      //       ),
                      //     ),
                      //
                      //     child: Center(
                      //       child: Icon(
                      //         (isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                      //         color: Color(0xFF616161),
                      //      ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  if (isExpanded) Column(children: [
                          Row(children: [
                            Text('suggested_accounts'.tr()),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: Row(children: [
                                Text('see_all'.tr(),
                                    style: const TextStyle(color: Color(0xFF616161))),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFF616161),
                                )
                              ]),
                            ),
                          ]),
                          Container(
                              height: 105,
                              child: ListView.builder(
                                  itemCount: 15,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      const FollowCardWidget())),
                        ]) else const SizedBox(height: 0)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
