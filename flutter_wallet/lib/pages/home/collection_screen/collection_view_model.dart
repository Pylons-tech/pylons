import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_screen.dart';
import 'package:pylons_wallet/services/third_party_services/network_info.dart';
import 'package:pylons_wallet/services/third_party_services/thumbnail_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';

class CollectionViewModel extends ChangeNotifier {
  WalletsStore walletsStore;

  ThumbnailHelper thumbnailHelper;

  CollectionViewModel({required this.walletsStore, required this.thumbnailHelper});

  List<NFT> assets = [];

  //big issue - should replace or unify into one
  List<NFT> recipes = [];

  List<NFT> creations = [];
  List<NFT> purchases = [];

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
    Collection(title: "art".tr(), icon: "art", type: 'cookbook'),
    // Collection(title: "tickets".tr(), icon: "tickets", type: 'cookbook'),
    // Collection(title: "transfer".tr(), icon: "transfer", type: 'cookbook'),
    Collection(title: "Easel", icon: "easel", type: 'app', app_name: "easel"),
    // Collection(title: "Avatar", icon: "pylons_logo.svg", type: 'app', app_name: "avatar"),
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

  Future<String?> generateVideoThumbnailIfRequired(String nftUrl, String nftName) async {
    return thumbnailHelper.generateVideoThumbnailIfRequired(nftUrl, nftName, thumbnailsPath);
  }

  Future loadPurchasesAndCreationsData() async {
    final loading = Loading()..showLoading();

    thumbnailsPath = (await getTemporaryDirectory()).path;
    try {
      final wallet = walletsStore.getWallets().value.last;
      final assets = <NFT>[];
      final creations = <NFT>[];
      final items = await walletsStore.getItemsByOwner(wallet.publicAddress);
      final trades = await walletsStore.getTrades(wallet.publicAddress);
      final cookbooks = await walletsStore.getCookbooksByCreator(wallet.publicAddress);

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
      loading.dismiss();
    } on Exception catch (_) {
      loading.dismiss();
      if (await GetIt.I.get<NetworkInfo>().isConnected == false) {
        "no_internet".show();
      }
    }
  }

  void refreshScreen() {
    notifyListeners();
  }
}

enum CollectionsType { purchases, creations }
