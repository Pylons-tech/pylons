import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';

class PylonsMarketplaceCard extends StatelessWidget {

  const PylonsMarketplaceCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child:ListTile(
                  leading: CircleAvatar(
                    child: FlutterLogo(size: 28.0),
                  ),
                  title: Text('Linda')
                )
              ),
              Padding(padding: EdgeInsets.only(right: 20),
              child: Text(
                      '10 min',
                      style:TextStyle(
                          fontSize: 12,
                          color: Color(0xFF201D1D)
                      )
                  )
              )
            ]
          ),
          Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 200.0,
                      child: Ink.image(
                        image: AssetImage('assets/images/Rectangle279.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      children:[
                        Padding(padding: EdgeInsets.only(left: 20),
                          child:Text('Title of Artwork',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF201D1D)
                              )
                          ),
                        )

                        ],
                    ),
                    Row(
                        children:[
                          IconButton(
                              icon: ImageIcon(
                                  AssetImage('assets/images/icon/union.png'),
                                  size: 24,
                                  color: Color(0xFF616161)
                              ),
                              onPressed: () {}
                          ),
                          Text('40'),
                          IconButton(
                              icon: ImageIcon(
                                  AssetImage('assets/images/icon/favorite_border.png'),
                                  size: 24,
                                  color: Color(0xFF616161)
                              ),
                              onPressed: () {}
                          ),
                          Text('142'),
                          Spacer(),
                          Padding(padding: EdgeInsets.only(right: 20),
                          child: Text('\$ 12.00'),
                          )
                        ]
                    )
                  ]
              )
          ),

        ]
    );
  }
}
