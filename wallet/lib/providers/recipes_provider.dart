import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/cookbook.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import 'package:tuple/tuple.dart';

import '../model/nft.dart';

class RecipesProvider extends ChangeNotifier {
  RecipesProvider({required this.repository, required this.address}) {
    repository.getStoredCookBooks().fold((l) => null, (List<Cookbook>? _cookBooks) {
      cookbooks = _cookBooks ?? [];
    });

    repository.getStoredCreations().fold((l) => null, (List<NFT>? _nftCreations) {
      nftCreations = _nftCreations ?? [];
    });

    repository.getNonNFTCreations().fold((l) => null, (List<Recipe>? _nonNFTCreations) {
      nonNftCreations = _nonNFTCreations ?? [];
    });
  }

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
    final localCookbooks = response.getOrElse(() => []);

    final localNFTCreations = <NFT>[];
    final localNonNFTCreations = <Recipe>[];

    for (final _cookbook in localCookbooks) {
      final recipeCreations = await getRecipes(_cookbook);

      localNFTCreations.addAll(recipeCreations.item1);
      localNonNFTCreations.addAll(recipeCreations.item2);
    }

    processCookBook(localCookbooks);
    processNFTCreations(localNFTCreations);
    processNonNFTCreations(localNonNFTCreations);

    log("Get Recipe finished", name: "RecipesProvider");
    notifyListeners();
  }

  Future<Tuple2<List<NFT>, List<Recipe>>> getRecipes(Cookbook cookbook) async {
    final recipesEither = await repository.getRecipesBasedOnCookBookId(cookBookId: cookbook.id);
    final recipes = recipesEither.getOrElse(() => []);

    final localNFTCreations = <NFT>[];
    final localNonNFTCreations = <Recipe>[];

    for (final recipe in recipes) {
      try {
        final nft = NFT.fromRecipe(recipe);
        localNFTCreations.add(nft);
      } catch (_) {
        localNonNFTCreations.add(recipe);
      }
    }

    return Tuple2(localNFTCreations, localNonNFTCreations);
  }

  void processCookBook(List<Cookbook> localCookbooks) {
    if (localCookbooks.isEmpty) {
      return;
    }
    cookbooks = localCookbooks;
    repository.storeCookBooks(cookbooks);
  }

  void processNFTCreations(List<NFT> _nftCreations) {
    if (_nftCreations.isEmpty) {
      return;
    }
    nftCreations = _nftCreations;
    repository.storeCreations(_nftCreations);
  }

  void processNonNFTCreations(List<Recipe> _nonNFTCreations) {
    if (_nonNFTCreations.isEmpty) {
      return;
    }
    nonNftCreations = _nonNFTCreations;
    repository.storeNonNFTCreations(_nonNFTCreations);
  }

  List<Cookbook> cookbooks = [];
  List<NFT> nftCreations = [];
  List<Recipe> nonNftCreations = [];
  String? address;
  Repository repository;
}
