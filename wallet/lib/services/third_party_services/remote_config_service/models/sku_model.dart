// "id": "pylons_10",
// "bonus": "",
// "subtitle": "$1.00",
// "pylons" : "10 PYLN"
//

import 'package:pylons_wallet/utils/svg_util.dart';

class SKUModel {
  String id;
  String bonus;
  String subtitle;
  String pylons;

  SKUModel({required this.id, required this.bonus, required this.subtitle, required this.pylons});
  factory SKUModel.fromJson(Map json) {
    return SKUModel(
      pylons: json['pylons'].toString(),
      subtitle: json['subtitle'].toString(),
      id: json['id'].toString(),
      bonus: json['bonus'].toString(),
    );
  }

  String getSvgAsset() {
    if(id == "pylons_10"){
      return SVGUtil.PYLON_ONE_CURRENCY;
    } else if (id == "pylons_35"){
      return SVGUtil.PYLON_THREE_CURRENCY;
    } else {
      return SVGUtil.PYLON_FIVE_CURRENCY;
    }
  }
}
