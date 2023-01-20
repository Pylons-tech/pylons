import '../modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart';

class UpdateRecipeModel {
  Recipe recipe = Recipe();
  String publicAddress = "";
  bool enabledStatus = true;
  String nftPrice = "";
  String denom = "";
  int quantity = 0;

  UpdateRecipeModel({
    required this.recipe,
    required this.publicAddress,
    required this.enabledStatus,
    required this.nftPrice,
    required this.denom,
    required this.quantity,
  });

  @override
  String toString() {
    return 'UpdateRecipeModel{recipe: $recipe, publicAddress: $publicAddress, enabledStatus: $enabledStatus, nftPrice: $nftPrice, denom: $denom, quantity: $quantity}';
  }
}
