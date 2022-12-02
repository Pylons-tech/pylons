import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

import '../model/nft.dart';
import '../services/repository/repository.dart';

class ItemsProvider extends ChangeNotifier {
  ItemsProvider({required this.repository, required this.address});

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

    for (final item in items) {
      await convertItemToNFT(item);
    }
    log("Convert item to NFT finished", name: "ItemsProvider");
    notifyListeners();
  }

  Future<void> convertItemToNFT(Item item) async {
    final nft = await NFT.fromItem(item);
    if (nft != null) {
      items.add(nft);
    }
  }

  List<NFT> items = [];
  String? address;
  Repository repository;
}
