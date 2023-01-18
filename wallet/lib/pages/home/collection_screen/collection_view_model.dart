import 'package:flutter/cupertino.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';

import '../../../providers/collections_tab_provider.dart';
import '../../../providers/recipes_provider.dart';

class CollectionViewModel extends ChangeNotifier {
  CollectionViewModel({
    required this.creations,
    required this.assets,
    required this.collectionsType,
    required this.nonNFTRecipes,
    required this.trades,
  });

  factory CollectionViewModel.fromState({
    required List<NFT> assets,
    required CollectionsType collectionsType,
    required RecipesProvider recipesProvider,
    required List<NFT> trades,
  }) {
    return CollectionViewModel(
      creations: recipesProvider.nftCreations,
      assets: assets,
      collectionsType: collectionsType,
      nonNFTRecipes: recipesProvider.nonNftCreations,
      trades: trades,
    );
  }

  final List<NFT> trades;
  final List<NFT> assets;
  final List<NFT> creations;
  final List<Recipe> nonNFTRecipes;
  final CollectionsType collectionsType;
}
