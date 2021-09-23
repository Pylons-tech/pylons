import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/pages/detail/detail_screen.dart';

class PylonsHistoryCard extends StatelessWidget {
  final String text;

  const PylonsHistoryCard({
    Key? key,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                leading: const CircleAvatar(
                  child: FlutterLogo(size: 28.0),
                ),
                // title: Text('Linda purchased \'Title of Artwork\''),
              contentPadding: EdgeInsets.zero,
                title: RichText(text: TextSpan(text: "Linda", style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.w500, fontSize: 16),
                  children: [
                    TextSpan(text: " ${'purchased'.tr()} ", style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),),
                    TextSpan(text: "'Title of Artwork'", style: TextStyle(
                      fontWeight: FontWeight.w500
                    ))
                  ]
                )),
                trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 16,
                    color: Color(0xFF616161)
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreenWidget(isOwner: true)));
                },
            ),
            Card(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                      child: Column(
                      children: [
                        Container(
                          child: Image(
                            image: AssetImage('assets/images/Rectangle 312.png'),
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Row(
                            children:[
                              Padding(
                                padding: const EdgeInsets.only(right: 4, left: 10),
                                child: GestureDetector(
                                    child: Image.asset('assets/icons/comment.png',
                                        width: 18,
                                        fit: BoxFit.fill,
                                        color: Color(0xFF616161)
                                    ),
                                    onTap: () {}
                                ),
                              ),
                              Text('40'),
                              const HorizontalSpace(10),
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: GestureDetector(
                                    child: Image.asset('assets/icons/like.png',
                                        width: 18,
                                        color: Color(0xFF616161)
                                    ),
                                    onTap: () {}
                                ),
                              ),
                              Text('142'),
                              Spacer(),
                              IconButton(
                                  icon: Icon(
                                      Icons.more_vert,
                                      size: 18,
                                      color: Color(0xFF616161)
                                  ),
                                  onPressed: () {}
                              ),
                            ]
                        )
                      ]
                  )
              ),
            ),


          ]
      ),
    );
/*
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFF1212C4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              text,
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
 */
  }
}
