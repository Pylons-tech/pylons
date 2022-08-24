import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/utils/extension.dart';

void main() {
  test('should create dynamic link for purchase', () {
    const String recipeId = "Easel_Recipe_auto_recipe_2022_04_12_204653_227";
    const String cookbookId =
        "Easel_CookBook_auto_cookbook_2022_04_12_204648_096";
    const String address = "pyloxyz";

    const String expectedDynamicLink =
        "https://wallet.pylons.tech/?recipe_id=$recipeId&cookbook_id=$cookbookId&address=$address";

    final dynamicLink =
        recipeId.createDynamicLink(cookbookId: cookbookId, address: address);

    expect(expectedDynamicLink, dynamicLink);
  });

  test('should create trade link', () {
    const String tradeId = "testTrade";
    const String address = "pyloxyz";

    const String expectedDynamicLink =
        "https://wallet.pylons.tech/?trade_id=$tradeId&address=$address";

    final dynamicLink = tradeId.createTradeLink(address: address);

    expect(expectedDynamicLink, dynamicLink);
  });

  test('should create purchase NFt Link ', () {
    const String tradeId = "testTrade";
    const String cookbookId = "cookbookTest";
    const String address = "pyloxyz";

    const String expectedDynamicLink =
        "https://wallet.pylons.tech/?cookbook_id=$cookbookId&item_id=$tradeId&address=$address";

    final dynamicLink =
        tradeId.createPurchaseNFT(cookBookId: cookbookId, address: address);

    expect(expectedDynamicLink, dynamicLink);
  });
}
