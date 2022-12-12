
import 'package:flutter/cupertino.dart';
import 'package:pylons_wallet/model/nft.dart';

import '../../../providers/collections_tab_provider.dart';

class CollectionViewModel extends ChangeNotifier {
  CollectionViewModel({required this.creations, required this.assets, required this.collectionsType});

  factory CollectionViewModel.fromState({
    required List<NFT> creations,
    required List<NFT> assets,
    required CollectionsType collectionsType,
  }) {
    return CollectionViewModel(creations: creations, assets: assets, collectionsType: collectionsType);
  }

  List<NFT> assets = [];
  List<NFT> creations = [];

  final CollectionsType collectionsType;
}
