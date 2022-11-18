import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pylons_wallet/model/favorites.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_screen.dart';
import 'package:pylons_wallet/services/third_party_services/thumbnail_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

import '../../../components/loading.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../pylons_app.dart';
import '../../../services/repository/repository.dart';
import '../../../utils/route_util.dart';

class CollectionViewModel extends ChangeNotifier {
  WalletsStore walletsStore;

  ThumbnailHelper thumbnailHelper;
  AccountPublicInfo accountPublicInfoInfo;
  Repository repository;

  CollectionViewModel({required this.walletsStore, required this.thumbnailHelper, required this.accountPublicInfoInfo, required this.repository});

  List<NFT> assets = [];

  //big issue - should replace or unify into one
  List<NFT> recipes = [];

  List<NFT> creations = [];
  List<NFT> purchases = [];
  List<NFT> favorites = [];

  String _colType = "art";

  String thumbnailsPath = "";

  CollectionsType _collectionsType = CollectionsType.purchases;

  CollectionsType get collectionsType => _collectionsType;

  set collectionsType(CollectionsType value) {
    if (value != collectionsType) {
      _collectionsType = value;
      notifyListeners();
    }
  }

  set colType(String value) {
    _colType = value;
    notifyListeners();
  }

  String get colType => _colType;

  List<Collection> collectionType = [
    Collection(title: LocaleKeys.art.tr(), icon: "art", type: 'cookbook'),
    Collection(title: "Easel", icon: "easel", type: 'app', app_name: "easel"),
  ];

  void init() {
    if (!walletsStore.getStateUpdatedFlag().hasObservers) {
      walletsStore.getStateUpdatedFlag().observe((flag) async {
        if (flag.newValue == true) {
          Timer(const Duration(milliseconds: 300), () async {
            loadPurchasesAndCreationsData();

            walletsStore.setStateUpdatedFlag(flag: false);
          });
        }
      }, fireImmediately: true);
    } else {
      Timer(const Duration(milliseconds: 300), () async {
        loadPurchasesAndCreationsData();
      });
    }
    Timer(const Duration(milliseconds: 300), () async {
      loadPurchasesAndCreationsData();
    });
  }

  Future loadPurchasesAndCreationsData() async {
    loadFavoritesData();
    thumbnailsPath = (await getTemporaryDirectory()).path;
    try {
      final assets = <NFT>[];
      final creations = <NFT>[];
      final items = await walletsStore.getItemsByOwner(accountPublicInfoInfo.publicAddress);
      final trades = await walletsStore.getTrades(accountPublicInfoInfo.publicAddress);
      final cookbooks = await walletsStore.getCookbooksByCreator(accountPublicInfoInfo.publicAddress);

      if (items.isNotEmpty) {
        await Future.wait(items.map((item) async {
          final nft = await NFT.fromItem(item);
          assets.add(nft);
        }).toList());
      }

      if (trades.isNotEmpty) {
        await Future.wait(trades.map((trade) async {
          final nft = await NFT.fromTrade(trade);
          assets.add(nft);
        }).toList());
      }

      if (cookbooks.isNotEmpty) {
        await Future.wait(cookbooks.map((cookbook) async {
          final recipes = await walletsStore.getRecipesByCookbookID(cookbook.id);

          for (final recipe in recipes) {
            final nft = NFT.fromRecipe(recipe);

            if (nft.appType.toLowerCase() == "easel" && cookbooks.any((cookbook) => cookbook.id == nft.cookbookID)) {
              creations.add(nft);
            }
          }
        }).toList());
      }

      purchases = assets;
      this.creations = creations;
      notifyListeners();
    } on Exception catch (_) {}
  }

  Future loadFavoritesData()async{
    final response = await repository.getAllFavorites();

    if(response.isRight()){
      final List<FavoritesModel> favModels = response.getOrElse(() => []);
      favorites.clear();
      for(final FavoritesModel favoritesModel in favModels){
        if(favoritesModel.type == NftType.TYPE_ITEM.name){
          final item = await repository.getItem(cookBookId: favoritesModel.cookbookId,itemId: favoritesModel.id);
          if(item.isRight()){
            favorites.add(await NFT.fromItem(item.toOption().toNullable()!));
          }
        }else{
          final item = await repository.getRecipe(cookBookId: favoritesModel.cookbookId,recipeId: favoritesModel.id);
          if(item.isRight()){
            favorites.add(NFT.fromRecipe(item.toOption().toNullable()!));
          }
        }
      }
    }
  }

  void shouldShowOwnerViewOrPurchaseViewForNFT({required NFT asset,required BuildContext context}) {
    if (asset.type == NftType.TYPE_RECIPE) {
      onRecipeClicked(asset);
    } else {
      Navigator.of(context).pushNamed(RouteUtil.ROUTE_OWNER_VIEW, arguments: asset).then((_) => {walletsStore.setStateUpdatedFlag(flag: true)});
    }
  }

  Future<void> onRecipeClicked(NFT asset) async {
    final loader = Loading()..showLoading();

    await asset.getOwnerAddress();

    loader.dismiss();
    Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamed(RouteUtil.ROUTE_OWNER_VIEW, arguments: asset).then((_) => {walletsStore.setStateUpdatedFlag(flag: true)});
  }

  String getNFTIcon(AssetType assetType) {
    switch (assetType) {
      case AssetType.Video:
        return SVGUtil.kSvgNftFormatVideo;
      case AssetType.Audio:
        return SVGUtil.kSvgNftFormatAudio;
      case AssetType.Pdf:
        return SVGUtil.kSvgNftFormatPDF;
      case AssetType.ThreeD:
        return SVGUtil.kSvgNftFormat3d;
      default:
        return SVGUtil.kSvgNftFormatImage;
    }
  }

  void refreshScreen() {
    notifyListeners();
  }
}

enum CollectionsType { purchases, creations, favorites }
