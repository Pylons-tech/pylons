import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/forms/card_info_form.dart';
import 'package:pylons_wallet/forms/create_trade_form.dart';
import 'package:pylons_wallet/pages/detail/detail_screen.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_info.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_work.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_history.dart';
import 'package:pylons_wallet/pages/home/notification.dart';
import 'package:pylons_wallet/pages/payment/payment_info_screen.dart';

class CollectionsScreenWidget extends StatefulWidget {
  const CollectionsScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CollectionsScreenWidget> createState() => _CollectionsScreenWidgetState();
}

class _CollectionsScreenWidgetState extends State<CollectionsScreenWidget> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: (){
            Navigator.pop(context);
          },
        )
      ),
      body: CustomScrollView(
          slivers:[
            SliverList(
            delegate: SliverChildListDelegate([
            //3 image card
                Container(
                  width: double.infinity,
                  height: 370,
                  decoration: BoxDecoration(

                    image: DecorationImage(
                      image: AssetImage("assets/images/Rectangle 156.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child:
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all( 16 ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0, 1.0],
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.transparent,
                            Colors.black,
                          ],
                        ),
                      ),
                      child: Column(
                          children: [
                            VerticalSpace(108),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Photography',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),

                            ),
                            SizedBox(height: 28),
                            Text('Description about the title Descritpion about the title Description about the title Description about the title',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white
                                )
                            ),
                            Spacer(),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.add, color: Colors.white),
                                      onPressed: (){
                                      }
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.more_vert, color: Colors.white),
                                      onPressed: (){}
                                  )
                                ]
                            ),
                            /** Staggered View */
                          ]
                      )
                  )
                ),
              ]),
            ),

            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver:  SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DetailScreenWidget(isOwner: true)));
                        },
                        child:Container(
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
                        )
                    );
                  },
                  staggeredTileBuilder: (index) {
                    return StaggeredTile.count((index == 1 || index == 6)? 2: 1,(index == 1 || index == 6)? 2: 1 );
                  }
              ),
            )


          ]
        ),
     );
  }
}
