import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

enum ViewType { viewGrid, viewList }

enum CollectionType { draft, published, forSale }

class CreatorHubViewModel extends ChangeNotifier {
  final Repository repository;

  CreatorHubViewModel(this.repository);

  CollectionType selectedCollectionType = CollectionType.draft;

  ViewType viewType = ViewType.viewGrid;


  int get publishedRecipesLength => nftPublishedList.length;

  changeSelectedCollection(CollectionType collectionType) {
    switch (collectionType) {
      case CollectionType.draft:
        selectedCollectionType = CollectionType.draft;
        notifyListeners();
        break;
      case CollectionType.published:
        selectedCollectionType = CollectionType.published;
        notifyListeners();
        break;
      case CollectionType.forSale:
        selectedCollectionType = CollectionType.forSale;
        notifyListeners();
        break;
    }
  }

  bool _publishCollapse = true;

  bool get publishCollapse => _publishCollapse;

  set publishCollapse(bool value) {
    _publishCollapse = value;
    notifyListeners();
  }

  bool _draftCollapse = true;

  bool get draftCollapse => _draftCollapse;

  set draftCollapse(bool value) {
    _draftCollapse = value;
    notifyListeners();
  }

  List<NFT> _nftDraftList = [];

  List<NFT> get nftDraftList => _nftDraftList;

  set nftDraftList(List<NFT> nftDraftList) {
    _nftDraftList = nftDraftList;
    notifyListeners();
  }

  List<NFT> _nftForSaleList = [];

  List<NFT> get nftForSaleList => _nftForSaleList;

  set nftForSaleList(List<NFT> nftForSale) {
    _nftForSaleList = nftForSale;
    notifyListeners();
  }

  final List<NFT> _nftPublishedList = [];

  List<NFT> get nftPublishedList => _nftPublishedList;

  String? getCookbookIdFromLocalDatasource() {
    return repository.getCookbookId();
  }

  void getTotalForSale() {
    _nftForSaleList = [];

    for (NFT nft in nftPublishedList) {
      if (nft.isEnabled && nft.amountMinted < int.parse(nft.quantity)) {
        _nftForSaleList.add(nft);
      }
    }

    notifyListeners();
  }

  Future<void> getPublishAndDraftData() async {
    await getRecipesList();
    getTotalForSale();
    notifyListeners();
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
    _nftPublishedList.clear();
    if (recipesList.isEmpty) {
      return;
    }
    for (final recipe in recipesList) {
      final nft = NFT.fromRecipe(recipe);
      _nftPublishedList.add(nft);
    }
  }

  void addToRecentNFT(NFT nft) {
    _nftPublishedList.add(nft);
    notifyListeners();
  }

  Future<void> getDraftsList() async {
    final loading = Loading()..showLoading(message: "loading".tr());

    final getNftResponse = await repository.getNfts();

    if (getNftResponse.isLeft()) {
      loading.dismiss();
      "something_wrong".tr().show();
      return;
    }

    nftDraftList = getNftResponse.getOrElse(() => []);

    loading.dismiss();

    notifyListeners();
  }

  Future<void> refreshDraftsList() async {
    final getNftResponse = await repository.getNfts();

    if (getNftResponse.isLeft()) {
      "something_wrong".tr().show();

      return;
    }

    nftDraftList = getNftResponse.getOrElse(() => []);

    notifyListeners();
  }

  Future<void> deleteNft(int? id) async {
    final deleteNftResponse = await repository.deleteNft(id!);

    if (deleteNftResponse.isLeft()) {
      "delete_error".tr().show();
      return;
    }
    nftDraftList.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void saveNFT({required NFT nft}) {
    repository.setCacheDynamicType(key: nftKey, value: nft);
    repository.setCacheString(key: fromKey, value: kDraft);
  }

  void updateViewType(ViewType selectedViewType) {
    viewType = selectedViewType;
    notifyListeners();
  }

  void updatePublishedNFTList({required NFT nft}) {
    _nftPublishedList.add(nft);
    _nftForSaleList.add(nft);
    notifyListeners();
  }
}
