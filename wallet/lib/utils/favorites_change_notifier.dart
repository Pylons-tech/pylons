import 'package:flutter/cupertino.dart';

import '../model/favorites.dart';
import '../model/nft.dart';
import '../services/repository/repository.dart';
import 'enums.dart';

class FavoritesChangeNotifier extends ChangeNotifier {
  final Repository repository;
  FavoritesChangeNotifier({required this.repository});

  List<NFT> favorites = [];

  Future<void> onInit() async {}

  Future<void> addToFavorites({required FavoritesModel favoritesModel}) async {
    if (favoritesModel.type == NftType.TYPE_ITEM.name) {
      final item = await repository.getItem(cookBookId: favoritesModel.cookbookId, itemId: favoritesModel.id);
      if (item.isRight()) {
        final nft = await NFT.fromItem(item.toOption().toNullable()!);
        favorites.add(nft!);
      }
    } else {
      final item = await repository.getRecipe(cookBookId: favoritesModel.cookbookId, recipeId: favoritesModel.id);
      if (item.isRight()) {
        favorites.add(NFT.fromRecipe(item.toOption().toNullable()!));
      }
    }
    notifyListeners();
  }

  Future<void> removeFromFavorites({required String recipeId}) async {
    for (final NFT nft in favorites) {
      if (nft.recipeID == recipeId) {
        favorites.remove(nft);
        break;
      }
    }
    notifyListeners();
  }
}
