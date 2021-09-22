import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/pages/detail/detail_screen.dart';

class PylonsMarketplaceCard extends StatelessWidget {
  const PylonsMarketplaceCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: const [
           Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  leading: CircleAvatar(
                    radius: 18,
                    child: FlutterLogo(size: 20.0),
                  ),
                  title: Text(
                    'Linda',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),),),
          Text('10 min',
              style: TextStyle(fontSize: 12, color: Color(0xFF201D1D)))
        ]),
        Card(
          margin: EdgeInsets.zero,
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
              InkWell(
                child:Image.asset(
                  'assets/images/Rectangle 312.png',
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreenWidget(isOwner: false,)));
                }
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text('Title of Artwork',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF201D1D))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                child: Row(children: [
                  GestureDetector(
                      child: ImageIcon(
                          AssetImage('assets/icons/comment.png'),
                          size: 16,
                          color: Color(0xFF616161)),
                      onTap: () {}),
                  const HorizontalSpace(4),
                  Text('40'),
                  const HorizontalSpace(10),
                  GestureDetector(
                      child: ImageIcon(
                          AssetImage('assets/icons/like.png'),
                          size: 16,
                          color: Color(0xFF616161)),
                      onTap: () {}),
                  const HorizontalSpace(4),
                  Text('142'),
                  Spacer(),
                  Text(
                    '\$ 12.00',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  )
                ]),
              )
            ])),
      ]),
    );
  }
}
