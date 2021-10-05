import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class SocialMediaScreen extends StatelessWidget {
  SocialMediaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        leadingWidth: 44,
        leading: Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/icons/close.png",
              fit: BoxFit.contain,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Link to Social Media",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        ),

      ),
      body: GridView.count(
        physics:const  NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        padding: EdgeInsets.all(10),
        crossAxisSpacing: 10,
        mainAxisSpacing: 1,
        childAspectRatio: 3.2/4,
        children: [
          _SocialCard(
            icon: "assets/icons/facebook.png",
            name: "Facebook",
            isAdded: true,
            accountName: "Choeun Park",
            onTap: (){},
          ),

          _SocialCard(
            icon: "assets/icons/instagram.png",
            name: "Instagram",
            isAdded: false,
            onTap: (){},
          ),

          _SocialCard(
            icon: "assets/icons/twitter.png",
            name: "Twitter",
            isAdded: false,
            onTap: (){},
          ),

          _SocialCard(
            icon: "assets/icons/website.png",
            name: "Website",
            isAdded: false,
            onTap: (){},
          ),

        ]

      ),
    );
  }
}

class _SocialCard extends StatelessWidget {
  const _SocialCard({
    Key? key,
    required this.icon,
    required this.name,
    required this.isAdded,
    required this.onTap,
    this.accountName = ""
  }) : super(key: key);

  final String icon;
  final String name;
  final String accountName;
  final bool isAdded;
  final VoidCallback onTap;



  @override
  Widget build(BuildContext context) {
    final screen = ScreenSizeUtil(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
              child: IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert, color: Color(0xFFC4C4C4),))),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 20),
              child: Column(
                children: [
                  Image.asset(icon,
                    width: screen.width(percent: 0.2),
                  ),
                  const VerticalSpace(20),
                  Text(name, style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16),),
                  const VerticalSpace(20),
                  if (!isAdded) SizedBox(
                    height: 30,
                      width: screen.width(percent: 0.3),
                      child: PylonsBlueButton(onTap: onTap, text: "Add account",),
                  ) else Text(accountName, style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 16),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
