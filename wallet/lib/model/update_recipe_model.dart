import '../modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart';

class UpdateRecipeModel {
  late Recipe recipe;
  late String publicAddress;
  late bool enabledStatus;
  late String nftPrice;
  late String denom;

  UpdateRecipeModel({required this.recipe, required this.publicAddress, required this.enabledStatus, required this.nftPrice, required this.denom});
}
