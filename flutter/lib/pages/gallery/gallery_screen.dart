import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:pylons_wallet/components/follow_card.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/account/account.dart';
import 'package:pylons_wallet/pages/edit_profile/edit_profile_screen.dart';
import 'package:pylons_wallet/pages/gallery/add_artwork.dart';
import 'package:pylons_wallet/pages/gallery/edit_cover_screen.dart';
import 'package:pylons_wallet/pages/gallery/gallery_tab_collection.dart';
import 'package:pylons_wallet/pages/gallery/gallery_tab_like.dart';
import 'package:pylons_wallet/pages/gallery/widget/custom_card_widget.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with SingleTickerProviderStateMixin {
  var isExpanded = false;
  final double bannerSize = 135;
  int tabIndex = 0;
  late TabController _tabController;

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

  void setExpndMode() {
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
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(kImage3),
                fit: BoxFit.cover
              )
            ),
            width: MediaQuery.of(context).size.width,
            height: bannerSize,
            child: Padding(
                padding: const EdgeInsets.only(right: 20.0, top: 56),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => EditCoverScreen())),
                  child: Container(
                    height: 18,
                    width: 79,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(97, 97, 97, 0.6),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        const ImageIcon(AssetImage('assets/icons/camera.png'),
                            size: 16, color: Colors.white),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          'edit_cover'.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Colors.white,
                              fontFamily: 'Inter'),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          color: Colors.white,
          child: Row(
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
        ),
        Positioned(
          top: bannerSize + 200,
          left: 0,
          right: 0,
          bottom: 0,
          child: _pages[tabIndex],
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
                    leading: UserImageWidget(imageUrl: kImage2),
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
                              builder: (context) =>
                                  const AccountScreenWidget()));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 70),
                      Text('${'followers'.tr()}: 23'),
                      const SizedBox(width: 50),
                      Text('${'following'.tr().toLowerCase()}: 20')
                    ],
                  ),
                  const VerticalSpace(10),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //     height: 30,
                      //     width: 138,
                      //     child: PylonsBlueButton(
                      //         onTap: () {}, text: 'follow'.tr())),
                      // SizedBox(
                      //   height: 30,
                      //   width: 30,
                      //   child: OutlinedButton(
                      //     onPressed: () {
                      //       setExandMode();
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       alignment: Alignment.center,
                      //       primary: Colors.white,
                      //       padding: const EdgeInsets.all(0),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius:
                      //             BorderRadius.circular(5), // <-- Radius
                      //       ),
                      //     ),
                      //     child: Center(
                      //       child: Icon(
                      //         isExpanded
                      //             ? Icons.keyboard_arrow_up
                      //             : Icons.keyboard_arrow_down,
                      //         color: const Color(0xFF616161),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EditProfileScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(
                                    color: Color(0xffCACACA),
                                  ))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Edit Profile",
                                  style: const TextStyle(
                                      fontSize: 15, color: Color(0xff616161))),
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
                  if (isExpanded)
                    Column(children: [
                      Row(children: [
                        Text('suggested_accounts'.tr()),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Row(children: [
                            Text('see_all'.tr(),
                                style:
                                    const TextStyle(color: Color(0xFF616161))),
                            const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF616161),
                            )
                          ]),
                        ),
                      ]),
                      SizedBox(
                          height: 105,
                          child: ListView.builder(
                              itemCount: 15,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  const FollowCardWidget())),
                    ])
                  else
                    const SizedBox(height: 0)
                ],
              ),
            )),
      ],
    );
  }
}
