import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

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
    return ItemsProvider(address: accountPublicInfo?.publicAddress, repository: repository)..getItems();
  }

  Future<void> getItems() async {
    if (address == null || address!.isEmpty) {
      return;
    }

    log("Get Items started", name: "ItemsProvider");

    final itemsEither = await repository.getListItemByOwner(owner: address!);
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

  Future<NFT?> convertItemToNFT(Item item) async {
    final nft = await NFT.fromItem(item);
    if (nft != null) {
      return nft;
    }
    return null;
  }

  List<NFT> items = [];
  String? address;
  Repository repository;

  void processItems(List<NFT> localItems) {
    items = localItems;
    repository.storePurchases(localItems);
  }
}
