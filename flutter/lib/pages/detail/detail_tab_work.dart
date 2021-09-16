import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/buttons/favorite_button.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';
import 'package:pylons_wallet/components/buttons/share_button.dart';

class DetailTabWorkWidget extends StatelessWidget {

  const DetailTabWorkWidget({
    Key? key,
  }) : super(key: key);

  static List<String> tags = [
    '#3D', '#Photography', '#Sculpture'
  ];

  static List<String> nfts= [
    'assets/images/Rectangle 312.png',
    'assets/images/Rectangle 312.png',
    'assets/images/Rectangle 312.png',
    'assets/images/Rectangle 312.png',
    'assets/images/Rectangle 312.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 100),
      //margin: const EdgeInsets.only(bottom: 100.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('Title of Artwork',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xFF080830))),
              Spacer(),
              FavoriteButton(onTap: (){}),
              ShareButton(onTap: (){})
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Wrap(
                spacing: 10,
                runSpacing: 5,
                children: tags.map((tag) =>
                  new Chip(
                    backgroundColor: Color(0xFFED8864),
                    label: new Text(tag),
                  )
                  ).toList()
              )
          ),

          //Description
          Align(
            alignment: Alignment.topLeft,
            child: Text('Description about the artwork', )
          ),

          //comments
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: FlutterLogo(size: 20.0),
                ),
                title: Text('jimin', style:TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.w600),),
                subtitle: Text('Really Love the artwork!', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)),
                trailing: Text('10 min', style: TextStyle(color: Color(0xFFC4C4C4), fontSize:16, fontWeight: FontWeight.w400)),
              ),
              Divider(),
              ListTile(
                leading: CircleAvatar(
                  child: FlutterLogo(size: 20.0),
                ),
                title: Text('jimin', style:TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.w600),),
                subtitle: Text('Really Love the artwork!', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)),
                trailing: Text('10 min', style: TextStyle(color: Color(0xFFC4C4C4), fontSize:16, fontWeight: FontWeight.w400)),
              ),
              Divider()
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Text('Related Items', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF242423))),
                  Spacer(),
                  MoreButton(onTap: (){})
                ],
              ),
              Container(
                height: 400,
                child: GridView.count(
                  shrinkWrap: false,
                  children:
                    nfts.map((nft) =>
                    new ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                       child: Image(
                         image: AssetImage(nft),
                         height:60,
                         fit: BoxFit.cover
                       )
                    )
                  ).toList(),
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(10),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 3.5/4,
                )
              )
            ],
          )

        ],
      )
    );
  }
}
