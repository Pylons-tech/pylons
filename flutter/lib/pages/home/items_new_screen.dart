import 'package:flutter/material.dart';
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
            centerTitle: true,
            leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const ImageIcon(
                    AssetImage('assets/images/icon/before.png'),
                    size: kIconSize,
                    color: kIconBGColor
                )
            ),
            title: Text('What\'s New', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: kTextBlackColor, fontFamily: 'Roboto', )),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            sliver:SliverStaggeredGrid.countBuilder(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Container(
                      decoration:BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(
                              Radius.circular(5)
                          )
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Image(
                            image: AssetImage('assets/images/Rectangle 312.png'),
                            fit: BoxFit.cover
                        ),
                      )
                  );
                },
                staggeredTileBuilder: (index) {
                  return StaggeredTile.count((index == 1 || index == 6)? 2: 1,(index == 1 || index == 6)? 2: 1 );
                }
            ),
          )

        ]
      )
    );
  }
}
