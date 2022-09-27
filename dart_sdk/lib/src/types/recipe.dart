import '../generated/pylons/payment_info.pb.dart';
import '../generated/pylons/recipe.pb.dart' as generated;
import '../pylons_wallet.dart';
import 'item.dart';
import 'execution.dart';

class Recipe {
  final generated.Recipe _native;

  Recipe(this._native);

  Future<Execution> executeWith (List<Item> inputs, {int CoinInputIndex = 0, List<PaymentInfo>Function()? paymentInfoGen} ) async {
    var ids = <String>[];
    var infos = <PaymentInfo>[];
    if (paymentInfoGen != null) infos = paymentInfoGen();

    inputs.forEach((item) {
      ids.add(item.getId());
    });
    // Pass this through to the low-level API
    var lowLevel = await PylonsWallet.instance.txExecuteRecipe(
        cookbookId: _native.cookbookId,
        recipeName: _native.name,
        itemIds: ids,
        coinInputIndex: 0,
        paymentInfo: infos);
    if (lowLevel.success) {
      return Execution(lowLevel.data!);
    } else {
      return Future.error(lowLevel.error);
    }
  }
}