import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/buttons/favorite_button.dart';
import 'package:pylons_wallet/components/buttons/more_button.dart';
import 'package:pylons_wallet/components/buttons/next_button.dart';
import 'package:pylons_wallet/components/buttons/share_button.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';

class DetailTabHistoryWidget extends StatelessWidget {

  const DetailTabHistoryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 100),
        //margin: const EdgeInsets.only(bottom: 100.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 20,
          padding: EdgeInsets.zero,
          itemBuilder: (_, index) => _HistoryCard(
            userName: "Linda",
            artWorkTitle: "Medusa ArtWork", userImage: kImage3,
            date: "23 Dec 2020", onTap: (){}),),
      //   child: Column(
      //     children: [
      //       //Creator
      //     _HistoryCard(),
      //     Container(
      //       margin: EdgeInsets.fromLTRB(16, 5, 16, 5),
      //       decoration: BoxDecoration(
      //         border: Border.all(
      //           color: Color(0xFFF1F1F2),  // red as border color
      //         ),
      //       ),
      //       child: ListTile(
      //         leading: CircleAvatar(
      //           child: FlutterLogo(),
      //         ),
      //         title:RichText(
      //           text: TextSpan(
      //             style: DefaultTextStyle.of(context).style,
      //             children: <TextSpan>[
      //               TextSpan(text: 'Linda', style: TextStyle(fontWeight: FontWeight.bold)),
      //               TextSpan(text: ' ${'purchased'.tr()}'),
      //               TextSpan(text: ' Title of Artwork', style: TextStyle(fontWeight: FontWeight.bold)),
      //             ],
      //           ),
      //         ),
      //         subtitle: Text('28 Dec, 2021',style: TextStyle(color: Color(0xFFC4C4C4))),
      //         trailing: NextButton(onTap: (){}),
      //       )
      //     ),
      //     Container(
      //       margin: EdgeInsets.fromLTRB(16, 5, 16, 5),
      //       decoration: BoxDecoration(
      //         border: Border.all(
      //           color: Color(0xFFF1F1F2),  // red as border color
      //         ),
      //       ),
      //       child: ListTile(
      //         leading: CircleAvatar(
      //           child: FlutterLogo(),
      //         ),
      //         title:RichText(
      //           text: TextSpan(
      //             style: DefaultTextStyle.of(context).style,
      //             children: <TextSpan>[
      //               TextSpan(text: 'Linda', style: TextStyle(fontWeight: FontWeight.bold)),
      //               TextSpan(text: ' ${'purchased'.tr()}'),
      //               TextSpan(text: ' Title of Artwork', style: TextStyle(fontWeight: FontWeight.bold)),
      //             ],
      //           ),
      //         ),
      //         subtitle: Text('28 Dec, 2021',style: TextStyle(color: Color(0xFFC4C4C4))),
      //         trailing: NextButton(onTap: (){}),
      //       ),
      //     )
      //   ]
      // )
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String userName;
  final String artWorkTitle;
  final String userImage;
  final String date;
  final VoidCallback onTap;
  const _HistoryCard({
    Key? key,
    required this.userName, required this.artWorkTitle, required this.userImage,
    required this.date, required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 5, 16, 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFF1F1F2),  // red as border color
        ),
      ),
      child: ListTile(
        leading: UserImageWidget(imageUrl: userImage,),
        title:RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: userName, style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' ${'purchased'.tr()} '),
              TextSpan(text: artWorkTitle, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        subtitle: Text(date, style: TextStyle(color: Color(0xFFC4C4C4))),
        trailing: NextButton(onTap: onTap),
      )
    );
  }
}
