import 'package:flutter/foundation.dart';

class CollectionsTabProvider extends ChangeNotifier {
  CollectionsType collectionsType = CollectionsType.purchases;

  void setCollectionType(CollectionsType collectionsType) {
    this.collectionsType = collectionsType;
    notifyListeners();
  }
}

enum CollectionsType {
  purchases,
  creations,
  non_nft_creations,
  trades,
}
