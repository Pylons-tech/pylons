import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/buttons/favorite_button.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';
import 'package:pylons_wallet/components/buttons/next_button.dart';
import 'package:pylons_wallet/components/buttons/share_button.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'collections.dart';

class GalleryTabCollectionWidget extends StatelessWidget {

  const GalleryTabCollectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double tileWidth = (MediaQuery. of(context). size. width - 30) / 3;

    return Padding(
        padding: EdgeInsets.only(bottom: 100, left: 10, right: 10),
        //margin: const EdgeInsets.only(bottom: 100.0),
        child: Column(
            children: [
              //Creator
              Card(
                child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child:Column(
                    children: [
                      Row(
                        children: [
                          Image(
                            image: AssetImage('assets/images/Rectangle 312.png'),
                            width: tileWidth * 2,
                            height: tileWidth * 2 + 2,
                            fit: BoxFit.cover
                          ),
                          SizedBox(width: 2),
                          Column(
                            children: [
                              Image(
                                image: AssetImage('assets/images/Rectangle 312.png'),
                                width: tileWidth,
                                height: tileWidth,
                                fit: BoxFit.cover
                              ),
                              SizedBox(height: 2),
                              Image(
                                image: AssetImage('assets/images/Rectangle 312.png'),
                                  width: tileWidth,
                                  height: tileWidth,
                                  fit: BoxFit.cover
                              ),

                            ]
                          )
                        ],
                      ),
                      Row(
                          children:[
                            Text('Photo Collection'),
                            Spacer(),
                            IconButton(
                                icon: ImageIcon(
                                  AssetImage('assets/images/icon/dots.png'),
                                  size: 24,
                                  color: Color(0xFF616161)
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CollectionsScreenWidget()));
                                }
                            ),
                          ]
                        )
                      ],
                    ),
                  ),
                ),
              Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:Column(
                    children: [
                      Row(
                        children: [
                          Image(
                              image: AssetImage('assets/images/Rectangle 312.png'),
                              width: tileWidth * 2,
                              height: tileWidth * 2 + 2,
                              fit: BoxFit.cover
                          ),
                          SizedBox(width: 2),
                          Column(
                              children: [
                                Image(
                                    image: AssetImage('assets/images/Rectangle 312.png'),
                                    width: tileWidth,
                                    height: tileWidth,
                                    fit: BoxFit.cover
                                ),
                                SizedBox(height: 2),
                                Image(
                                    image: AssetImage('assets/images/Rectangle 312.png'),
                                    width: tileWidth,
                                    height: tileWidth,
                                    fit: BoxFit.cover
                                ),

                              ]
                          )
                        ],
                      ),
                      Row(
                          children:[
                            Text('Photo Collection'),
                            Spacer(),
                            IconButton(
                                icon: ImageIcon(
                                    AssetImage('assets/images/icon/dots.png'),
                                    size: 24,
                                    color: Color(0xFF616161)
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CollectionsScreenWidget()));
                                }
                            ),
                          ]
                      )
                    ],
                  ),
                ),
              ),
            ]
        )
    );
  }
}
