import 'package:evently/models/events.dart';
import 'package:evently/repository/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

enum CollectionType { draft, forSale, history }

@lazySingleton
class EventHubViewModel extends ChangeNotifier {
  EventHubViewModel(this.repository);

  final Repository repository;

  List<Events> _eventPublishedList = [];

  List<Events> get eventPublishedList => _eventPublishedList;

  List<Events> _eventForSaleList = [];

  List<Events> get eventForSaleList => _eventForSaleList;

  set setEventForSaleList(List<Events> nftForSale) {
    _eventForSaleList = nftForSale;
    notifyListeners();
  }

  set setEventPublishList(List<Events> events) {
    _eventPublishedList = events;
    notifyListeners();
  }

  void updatePublishedEventList({required Events events}) {
    _eventPublishedList.add(events);
    _eventForSaleList.add(events);
    notifyListeners();
  }

  CollectionType selectedCollectionType = CollectionType.draft;

  void changeSelectedCollection(CollectionType collectionType) {
    switch (collectionType) {
      case CollectionType.draft:
        selectedCollectionType = CollectionType.draft;
        notifyListeners();
        break;

      case CollectionType.forSale:
        selectedCollectionType = CollectionType.forSale;
        notifyListeners();
        break;

      case CollectionType.history:
        selectedCollectionType = CollectionType.history;
        notifyListeners();
        break;
    }
  }

  String? getCookbookIdFromLocalDatasource() {
    return repository.getCookbookId();
  }

  Future<void> getRecipesList() async {
    final isPylonsExist = await PylonsWallet.instance.exists();

    if (!isPylonsExist) {
      return;
    }

    final cookBookId = getCookbookIdFromLocalDatasource();
    if (cookBookId == null) {
      return;
    }

    final recipesListEither = await repository.getRecipesBasedOnCookBookId(cookBookId: cookBookId);

    if (recipesListEither.isLeft()) {
      return;
    }

    final recipesList = recipesListEither.getOrElse(() => []);

    if (recipesList.isEmpty) {
      return;
    }
    for (final recipe in recipesList) {
      final nft = Events.fromRecipe(recipe);
      _eventPublishedList.add(nft);
    }
  }
}
