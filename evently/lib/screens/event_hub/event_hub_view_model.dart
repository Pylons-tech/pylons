import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/models/events.dart';
import 'package:evently/repository/repository.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/extension_util.dart';
import 'package:evently/widgets/loading_with_progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

enum CollectionType { draft, forSale, history }

enum ViewType { viewGrid, viewList }

@lazySingleton
class EventHubViewModel extends ChangeNotifier {
  EventHubViewModel(this.repository);

  final Repository repository;

  List<Events> _eventPublishedList = [];

  List<Events> get eventPublishedList => _eventPublishedList;

  List<Events> _eventForDraftList = [];

  ViewType viewType = ViewType.viewGrid;

  void updateViewType(ViewType selectedViewType) {
    viewType = selectedViewType;
    notifyListeners();
  }

  List<Events> get eventForDraftList => _eventForDraftList;

  List<Events> get eventForSaleList => _eventForDraftList;

  set setEventForDraftList(List<Events> nftForSale) {
    _eventForDraftList = nftForSale;
    notifyListeners();
  }

  set setEventPublishList(List<Events> events) {
    _eventPublishedList = events;
    notifyListeners();
  }

  void updatePublishedEventList({required Events events}) {
    _eventPublishedList.add(events);
    _eventForDraftList.add(events);
    notifyListeners();
  }

  CollectionType _selectedCollectionType = CollectionType.draft;

  CollectionType get selectedCollectionType => _selectedCollectionType;

  void changeSelectedCollection(CollectionType collectionType) {
    switch (collectionType) {
      case CollectionType.draft:
        _selectedCollectionType = CollectionType.draft;
        notifyListeners();
        break;

      case CollectionType.forSale:
        _selectedCollectionType = CollectionType.forSale;
        notifyListeners();
        break;

      case CollectionType.history:
        _selectedCollectionType = CollectionType.history;
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

  Future<void> getDraftsList() async {
    final loading = LoadingProgress()..showLoadingWithProgress(message: LocaleKeys.loading.tr());

    final getEventResponse = await repository.getAllEvents();

    if (getEventResponse.isLeft()) {
      loading.dismiss();
      LocaleKeys.something_wrong.tr().show();
      return;
    }

    List<Events> draftEvent = getEventResponse.getOrElse(() => []);
    setEventForDraftList = draftEvent;

    loading.dismiss();

    notifyListeners();
  }

  Future<void> getPublishAndDraftData() async {
    await getRecipesList();
    await getDraftsList();
    notifyListeners();
  }

  Future<void> deleteNft(int? id) async {
    final deleteNftResponse = await repository.deleteNft(id!);

    if (deleteNftResponse.isLeft()) {
      LocaleKeys.delete_error.tr().show();
      return;
    }
    eventForDraftList.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void saveEvent({required Events events}) {
    repository.setCacheDynamicType(key: eventKey, value: events);
    repository.setCacheString(key: fromKey, value: kDraft);
  }
}
