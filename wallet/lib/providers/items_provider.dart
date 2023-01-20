import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

import '../model/common.dart';
import '../model/nft.dart';
import '../services/repository/repository.dart';

class ItemsProvider extends ChangeNotifier {
  ItemsProvider({required this.repository, required this.address}) {
    repository.getStoredPurchases().fold((l) => null, (List<NFT>? _items) {
      items = _items ?? [];
    });
  }

  factory ItemsProvider.fromAccountProvider({
    required AccountPublicInfo? accountPublicInfo,
    required Repository repository,
  }) {
    return ItemsProvider(address: accountPublicInfo?.publicAddress, repository: repository)
      ..getItems()
      ..getTrades();
  }

  Future<void> getItems() async {
    if (address == null || address!.isEmpty) {
      return;
    }

    log("Get Items started", name: "ItemsProvider");

    final itemsEither = await repository.getListItemByOwner(owner: Address(address!));
    log("Get Items finished", name: "ItemsProvider");
    final items = itemsEither.getOrElse(() => []);

    final localItems = <NFT>[];

    for (final item in items) {
      final nft = await convertItemToNFT(item);
      if (nft != null) {
        localItems.add(nft);
      }
    }

    processItems(localItems);
    log("Convert item to NFT finished", name: "ItemsProvider");
    notifyListeners();
  }

  Future<void> getTrades() async {
    final getTradesEither = await repository.getTradesBasedOnCreator(creator: Address(address!));
    final trades = getTradesEither.getOrElse(() => []);

    final localTrades = <NFT>[];

    for (final trade in trades) {
      final nft = await convertTradeToNFT(trade);
      if (nft != null) {
        localTrades.add(nft);
      }
    }
    processTrades(localTrades);

    notifyListeners();
  }

  Future<NFT?> convertItemToNFT(Item item) async {
    final nft = await NFT.fromItem(item);
    if (nft != null) {
      return nft;
    }
    return null;
  }

  Future<NFT?> convertTradeToNFT(Trade item) async {
    //TODO handle non easel trades
    final nft = await NFT.fromTrade(item);
    return nft;
  }

  void processTrades(List<NFT> localTrades) {
    trades = localTrades;
    notifyListeners();

    //TODO cache trades as well
    // repository.storePurchases(localItems);
  }

  void processItems(List<NFT> localItems) {
    items = localItems;
    repository.storePurchases(localItems);
  }

  List<NFT> items = [];
  List<NFT> trades = [];
  String? address;
  Repository repository;
}
