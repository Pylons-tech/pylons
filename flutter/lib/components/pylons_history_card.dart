import 'package:flutter/material.dart';
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
                title: RichText(text: const TextSpan(text: "Linda", style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.w500, fontSize: 16),
                  children: [
                    TextSpan(text: " purchased ", style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),),
                    TextSpan(text: "'Title of Artwork'", style: TextStyle(
                      fontWeight: FontWeight.w500
                    ))
                  ]
                )),
                trailing: ImageIcon(
                    AssetImage('assets/images/icon/more.png'),
                    size: 24,
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
                              IconButton(
                                  icon: ImageIcon(
                                      AssetImage('assets/images/icon/dots.png'),
                                      size: 24,
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
