import 'package:pylons_wallet/gen/assets.gen.dart';

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
      return Assets.images.icons.pylon1hCurrency;
    } else if (id == "pylons_35"){
      return Assets.images.icons.pylon3hCurrency;
    } else {
      return Assets.images.icons.pylon5hCurrency;
    }
  }
}
