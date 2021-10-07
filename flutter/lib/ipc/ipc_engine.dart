import 'dart:async';

import 'package:uni_links/uni_links.dart';

class IPCEngine {


  late StreamSubscription _sub;



  void init(){

    _sub = linkStream.listen((String? link) {
      print(link);
      // Link contains the data that the wallet need
    }, onError: (err) {

    });

  }





  void dispose(){
    _sub.cancel();
  }



}