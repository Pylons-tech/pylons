import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pylons_wallet/constants/constants.dart';

class ItemsNewScreenWidget extends StatefulWidget {
  const ItemsNewScreenWidget({Key? key}) : super(key: key);

  @override
  State<ItemsNewScreenWidget> createState() => _ItemsNewScreenWidgetState();
}

class _ItemsNewScreenWidgetState extends State<ItemsNewScreenWidget> {


  static const layout = [
    [1,1],
    [2,2],
    [1,1],
    [1,1],
    [1,1],
    [1,1],
    [2,2],
    [1,1],
    [1,1],
  ];

  static const items = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            forceElevated: true,
            toolbarHeight: kAppBarNormalSize,
            collapsedHeight: kAppBarNormalSize,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(
                    Icons.keyboard_arrow_left_rounded,
                    size: kIconSize,
                    color: kIconBGColor
                )
            ),
            title: Text('what_is_new'.tr(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: kTextBlackColor, fontFamily: 'Roboto', )),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            sliver:SliverStaggeredGrid.countBuilder(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                itemCount: 16,
                itemBuilder: (context, index) {
                  return Container(
                      decoration:BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(
                              Radius.circular(5)
                          )
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        child: CachedNetworkImage(
                            imageUrl: index % 2 == 0 ? kImage1 : kImage3,
                            fit: BoxFit.cover
                        ),
                      )
                  );
                },
                staggeredTileBuilder: (index) {
                  return StaggeredTile.count((index == 1 || index == 6) ? 2: 1,(index == 1 || index == 6)? 2: 1 );
                }
            ),
          )

        ]
      )
    );
  }
}
