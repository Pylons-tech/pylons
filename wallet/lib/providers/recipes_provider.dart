import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/cookbook.pb.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';

import '../model/nft.dart';

class RecipesProvider extends ChangeNotifier {
  RecipesProvider({required this.repository, required this.address});

  factory RecipesProvider.fromAccountProvider({
    required AccountPublicInfo? accountPublicInfo,
    required Repository repository,
  }) {
    return RecipesProvider(address: accountPublicInfo?.publicAddress, repository: repository)..getCookBooks();
  }

  Future<void> getCookBooks() async {
    log("Get Cookbooks started", name: "RecipesProvider");
    if (address == null || address!.isEmpty) {
      return;
    }
    final response = await repository.getCookbooksByCreator(creator: address!);

    log("Get Cookbooks finished", name: "RecipesProvider");
    cookbooks = response.getOrElse(() => []);

    creations = <NFT>[];

    for (final cookbook in cookbooks) {
      await getRecipe(cookbook);
    }
    log("Get Recipe finished", name: "RecipesProvider");
    notifyListeners();
  }

  Future<void> getRecipe(Cookbook cookbook) async {
    final recipesEither = await repository.getRecipesBasedOnCookBookId(cookBookId: cookbook.id);
    final recipes = recipesEither.getOrElse(() => []);

    for (final recipe in recipes) {
      final nft = NFT.fromRecipe(recipe);

      if (nft.appType.toLowerCase() == "easel" && cookbooks.any((cookbook) => cookbook.id == nft.cookbookID)) {
        creations.add(nft);
      }
    }
  }

  List<Cookbook> cookbooks = [];
  List<NFT> creations = [];
  String? address;
  Repository repository;
}
