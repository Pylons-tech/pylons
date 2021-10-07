import 'dart:async';

import 'package:uni_links/uni_links.dart';

class IPCEngine {


  late StreamSubscription _sub;



  void init(){

    _sub = linkStream.listen((String? link) {
      print(link);
      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

  }





  void dispose(){
    _sub.cancel();
  }



}