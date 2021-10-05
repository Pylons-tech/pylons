import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddArtworkGridWidget extends StatefulWidget {
  const AddArtworkGridWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AddArtworkGridWidget> createState() => _AddArtworkGridWidgetState();
}

class _AddArtworkGridWidgetState extends State<AddArtworkGridWidget> with SingleTickerProviderStateMixin {

  List<String> listTitle = [
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
  ];
  List<bool> listTitlestatus = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var totalNum = 0;
    final tileWidth = (MediaQuery. of(context). size. width - 32 - 32) /3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Row(children: [
              const Text('15',),
              const SizedBox(width: 10),
              Text('add'.tr(), style: const TextStyle(color: Colors.white),)
            ])
          )],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: 105,
                child: ListView.builder(
                    itemCount: 15,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index)=>Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                      child: Stack(
                          children: [
                            Card(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                color: const Color(0xFFC4C4C4),
                                    width: 60,
                                    height: 68
                                )
                              )
                            ),
                            const Positioned( // will be positioned in the top right of the container
                                top: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Color(0x80000000),
                                  child:Icon(
                                      Icons.close,
                                      size: 15,
                                    color: Colors.white,
                                  ),
                                )
                            )
                          ]
                      )
                    )

                )
            ),

            const Divider(),
            SizedBox(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 20,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (context, index){
                  return Stack(
                      children: [
                        Card(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: listTitlestatus[index] ? ( Border.all(color: const Color(0xFF1212C4), width: 3)) : (null)
                                    ),
                                    width: tileWidth,
                                    height: tileWidth,
                                    child: InkWell(
                                      onTap: (){
                                        setState((){
                                          if(listTitlestatus[index]){
                                            totalNum = totalNum - 1;
                                          }else{
                                            totalNum = totalNum + 1;
                                          }
                                          listTitlestatus[index] = !listTitlestatus[index];
                                        });
                                      },
                                      child: const Image(
                                          image: AssetImage('assets/images/Rectangle 312.png'),
                                          fit: BoxFit.cover
                                      )
                                    )
                                )
                            )
                        ),
                        Positioned( // will be positioned in the top right of the container
                            top: 10,
                            right: 20,
                            child: Container(
                              decoration:  BoxDecoration(
                                shape: BoxShape.circle,
                                border:  Border.all(
                                  color: listTitlestatus[index] ? const Color(0xFFC4C4C4) : const Color(0x80201D1D),
                                  width: 2.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor:listTitlestatus[index] ? const Color(0x801212C4) : const Color(0x80000000),
                                child: Text(listTitlestatus[index] ? (index.toString()) : '', style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 10))
                                /*
                                child:Text(indx.toString(), style: TextStyle()),
                                 */
                              ),
                            )
                        )
                      ]
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
