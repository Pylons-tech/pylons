import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class PylonsTrendingNewCard extends StatelessWidget {

  const PylonsTrendingNewCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const layout = [
      [1, 1],
      [2, 2],
      [1, 1],
      [1, 1],
      [1, 1],
      [1, 1]
    ];

    return Container(
        padding: EdgeInsets.only(right: 6),
        width: 325,
        child:

        Row(
            children: [
              Column(
                children: [
                  Image(
                      image: AssetImage('assets/images/Rectangle 312.png'),
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover
                  ),
                  SizedBox(height: 5.0),
                  Image(
                      image: AssetImage('assets/images/Rectangle 312.png'),
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover
                  ),
                  SizedBox(height: 5.0),
                  Image(
                      image: AssetImage('assets/images/Rectangle 312.png'),
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover
                  ),
               ],
              ),
              SizedBox(width:5.0),
              Column(
                children: [
                  Image(
                      image: AssetImage('assets/images/Rectangle 312.png'),
                      width: 205.0,
                      height: 205.0,
                      fit: BoxFit.cover
                  ),
                  SizedBox(height: 5.0,),
                  Row(
                    children: [
                      Image(
                          image: AssetImage('assets/images/Rectangle 312.png'),
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover
                      ),
                      SizedBox(width: 5.0),
                      Image(
                          image: AssetImage('assets/images/Rectangle 312.png'),
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover
                      ),
                    ],
                  )
                ],
              )
           ]
        )
    );
  }
}
