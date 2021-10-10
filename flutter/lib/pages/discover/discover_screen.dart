import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/detail/detail_screen.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {

  List list = ["asdf", "asdf", "aaaa"];
  List chips = [
    "+",
    "#3D",
    "#Photography",
    "#Sculpture",
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          elevation: 0,
          toolbarHeight: kAppBarNormalSize,
          collapsedHeight: kAppBarNormalSize,
          backgroundColor: Colors.white,
          stretch: true,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
            child: GFSearchBar(
              searchQueryBuilder: (query, list) {
                return list
                    .where((item) => item
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();
              },
              overlaySearchListItemBuilder: (item) {
                return Container(
                    width: screenSize.width(),
                    padding: const EdgeInsets.all(8),
                    child: Text(item.toString(),
                        style: const TextStyle(fontSize: 18)));
              },
              onItemSelected: (item) {
                setState(() {});
              },
              searchList: list,
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          //3 image card
          Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: chips
                      .map((tag) => Chip(
                            backgroundColor: const Color(0xFFED8864),
                            label: Text(tag.toString()),
                          ))
                      .toList())),
          const VerticalSpace(20),
        ])),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          sliver: SliverStaggeredGrid.countBuilder(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              itemCount: 15,
              itemBuilder: (context, index) {
                return Container(
                    decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: InkWell(
                          child: CachedNetworkImage(
                              imageUrl: _getImage(index),
                              fit: BoxFit.cover),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DetailScreenWidget(
                                            isOwner: false)));
                          },
                        )));
              },
              staggeredTileBuilder: (index) {
                return StaggeredTile.count((index == 1 || index == 6) ? 2 : 1,
                    (index == 1 || index == 6) ? 2 : 1);
              }),
        )
      ],
    );
  }


  String _getImage(int index){
    switch(index % 4){
      case 1:
        return  kImage1;

      case 2:
        return kImage2;

      case 3:
        return kImage3;

      default:
        return kImage;
    }
  }
}
