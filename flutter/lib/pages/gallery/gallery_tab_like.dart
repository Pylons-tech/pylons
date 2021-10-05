import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/buttons/next_button.dart';
import 'package:pylons_wallet/components/user_image_widget.dart';
import 'package:pylons_wallet/constants/constants.dart';

class GalleryTabLikeWidget extends StatelessWidget {

  const GalleryTabLikeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        //margin: const EdgeInsets.only(bottom: 100.0),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (_, index) => _LikeWidget(userName: "Linda$index",
                userImage: kImage2, artWorkTitle: "Artwork$index", date: "Dec 20, 2020"))
    );
  }
}

class _LikeWidget extends StatelessWidget {
  final String userName;
  final String userImage;
  final String artWorkTitle;
  final String date;

  const _LikeWidget({
    Key? key,
    required this.userName,
    required this.userImage,
    required this.artWorkTitle,
    required this.date
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFF1F1F2),  // red as border color
        ),
      ),
      child: ListTile(
        leading: UserImageWidget(imageUrl: userImage),
        title:RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' ${'purchased'.tr()} '),
              TextSpan(text: artWorkTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        subtitle: Text(date, style: const TextStyle(color: Color(0xFFC4C4C4))),
        trailing: NextButton(onTap: (){}),
      ),
    );
  }
}
