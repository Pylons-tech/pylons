import 'dart:core';

import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/item.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/trade.pb.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';

// ignore_for_file: must_be_immutable

class NFT extends Equatable {
  String url = "";
  String thumbnailUrl = "";
  String name = "";
  String description = "";
  String denom = "";
  String price = "0";
  String creator = "";
  String owner = "";
  int amountMinted = 0;
  int quantity = 0;
  String tradePercentage = "0";
  String cookbookID = "";
  String recipeID = "";
  String itemID = "";
  String width = "";
  String height = "";
  String appType = "";
  String tradeID = "";
  String ownerAddress = "";
  IBCCoins ibcCoins = IBCCoins.upylon;

  NftType type = NftType.TYPE_ITEM;
  AssetType assetType = AssetType.Image;
  String duration = "";
  String fileSize = "";
  String hashtags = "";
  String createdAt = "";
  bool realWorld = false;

  NFT({
    this.url = "",
    this.thumbnailUrl = "",
    this.name = "",
    this.description = "",
    this.denom = "",
    this.price = "0",
    this.type = NftType.TYPE_ITEM,
    this.creator = "",
    this.itemID = "",
    this.cookbookID = "",
    this.recipeID = "",
    this.owner = "",
    this.width = "",
    this.height = "",
    this.tradePercentage = "0",
    this.amountMinted = 0,
    this.quantity = 0,
    this.appType = "",
    required this.ibcCoins,
    this.tradeID = "",
    this.assetType = AssetType.Image,
    this.duration = "",
    this.fileSize = "",
    this.hashtags = "",
    this.createdAt = "",
    this.realWorld = false,
  });

  Future<String> getOwnerAddress() async {
    if (ownerAddress.isEmpty) {
      final walletsStore = GetIt.I.get<WalletsStore>();
      final cookbook = await walletsStore.getCookbookById(cookbookID);
      ownerAddress = cookbook?.creator ?? "";

      if (owner.isEmpty && type != NftType.TYPE_RECIPE) {
        owner = await walletsStore.getAccountNameByAddress(ownerAddress);
      }
    }
    return ownerAddress;
  }

  static Future<NFT> fromItem(Item item) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final owner = await walletsStore.getAccountNameByAddress(item.owner);
    return NFT(
      recipeID: item.recipeId,
      name: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kName).value,
      url: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kNFTURL).value.changeDomain(),
      thumbnailUrl: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kThumbnailUrl, orElse: () => StringKeyValue(key: kThumbnailUrl, value: "")).value.changeDomain(),
      description: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kDescription).value,
      fileSize: getFileSize(item),
      creator: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kCreator, orElse: () => StringKeyValue(key: kCreator, value: "")).value,
      appType: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kAppType, orElse: () => StringKeyValue(key: kAppType, value: "")).value,
      width: item.longs.firstWhere((longKeyValue) => longKeyValue.key == kWidth, orElse: () => LongKeyValue(key: kWidth, value: Int64())).value.toString(),
      height: item.longs.firstWhere((longKeyValue) => longKeyValue.key == kHeight, orElse: () => LongKeyValue(key: kHeight, value: Int64())).value.toString(),
      itemID: item.id,
      cookbookID: item.cookbookId,
      owner: owner,
      ibcCoins: IBCCoins.upylon,
      assetType: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kNftFormat).value.toAssetTypeEnum(),
      duration: item.longs.firstWhere((longKeyValue) => longKeyValue.key == kDuration, orElse: () => LongKeyValue(key: kDuration, value: Int64())).value.toInt().toSeconds(),
      hashtags: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kHashtags, orElse: () => StringKeyValue(key: kHashtags, value: "")).value,
      realWorld: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kRealWorld, orElse: () => StringKeyValue(key: kRealWorld, value: "false")).value == "true",
    );
  }

  static String getFileSize(Item item) => item.strings.firstWhereOrNull((strKeyValue) => strKeyValue.key == kFileSize)?.value ?? "";

  static Future<NFT> fromTrade(Trade trade) async {
    final walletsStore = GetIt.I.get<WalletsStore>();

    //retrieve Item
    final cookbookID = trade.itemOutputs.first.cookbookId;
    final itemID = trade.itemOutputs.first.itemId;
    final item = await walletsStore.getItem(cookbookID, itemID) ?? Item.create();
    final owner = await walletsStore.getAccountNameByAddress(trade.creator);

    return NFT(
      type: NftType.TYPE_TRADE,
      name: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kName).value,
      url: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kNFTURL).value.changeDomain(),
      thumbnailUrl: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kThumbnailUrl, orElse: () => StringKeyValue(key: kThumbnailUrl, value: "")).value.changeDomain(),
      description: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kDescription).value,
      fileSize: getFileSize(item),
      creator: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kCreator, orElse: () => StringKeyValue(key: kCreator, value: "")).value,
      appType: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kAppType, orElse: () => StringKeyValue(key: kAppType, value: "")).value,
      width: item.longs.firstWhere((longKeyValue) => longKeyValue.key == kWidth, orElse: () => LongKeyValue(key: kWidth, value: Int64())).value.toString(),
      height: item.longs.firstWhere((longKeyValue) => longKeyValue.key == kHeight, orElse: () => LongKeyValue(key: kHeight, value: Int64())).value.toString(),
      price: trade.coinInputs.first.coins.first.amount,
      denom: trade.coinInputs.first.coins.first.denom,
      itemID: item.id,
      cookbookID: item.cookbookId,
      owner: owner,
      tradeID: trade.id.toString(),
      ibcCoins: trade.coinInputs.first.coins.first.denom.toIBCCoinsEnum(),
      assetType: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kNftFormat).value.toAssetTypeEnum(),
      duration: item.longs.firstWhere((longKeyValue) => longKeyValue.key == kDuration, orElse: () => LongKeyValue(key: kDuration, value: Int64())).value.toInt().toSeconds(),
      hashtags: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kHashtags, orElse: () => StringKeyValue(key: kHashtags, value: "")).value,
      realWorld: item.strings.firstWhere((strKeyValue) => strKeyValue.key == kRealWorld, orElse: () => StringKeyValue(key: kRealWorld, value: "false")).value == "true",
    );
  }

  factory NFT.fromRecipe(Recipe recipe) {
    final royalties = (recipe.entries.itemOutputs.firstOrNull?.tradePercentage.fromBigInt().toInt() ?? 0).toString();
    final createdAt = recipe.createdAt.toInt().getCreatedAt();

    return NFT(
      type: NftType.TYPE_RECIPE,
      recipeID: recipe.id,
      cookbookID: recipe.cookbookId,
      name: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kName, orElse: () => StringParam()).value ?? "",
      url: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kNFTURL, orElse: () => StringParam()).value.changeDomain() ?? "",
      thumbnailUrl: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kThumbnailUrl, orElse: () => StringParam()).value.changeDomain() ?? "",
      description: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kDescription, orElse: () => StringParam()).value ?? "",
      fileSize: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kFileSize, orElse: () => StringParam()).value ?? "",
      appType: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kAppType, orElse: () => StringParam()).value ?? "",
      creator: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kCreator, orElse: () => StringParam()).value ?? "",
      width: recipe.entries.itemOutputs.firstOrNull?.longs.firstWhere((longKeyValue) => longKeyValue.key == kWidth, orElse: () => LongParam()).weightRanges.firstOrNull?.upper.toString() ?? "0",
      height: recipe.entries.itemOutputs.firstOrNull?.longs.firstWhere((longKeyValue) => longKeyValue.key == kHeight, orElse: () => LongParam()).weightRanges.firstOrNull?.upper.toString() ?? "0",
      amountMinted: int.parse(recipe.entries.itemOutputs.firstOrNull?.amountMinted.toString() ?? "0"),
      quantity: recipe.entries.itemOutputs.firstOrNull?.quantity.toInt() ?? 0,
      tradePercentage: royalties == "0" ? kNone : "$royalties%",
      price: recipe.coinInputs.firstOrNull?.coins.firstOrNull?.amount ?? "0",
      denom: recipe.coinInputs.firstOrNull?.coins.firstOrNull?.denom ?? "",
      ibcCoins: recipe.coinInputs.firstOrNull?.coins.firstOrNull?.denom.toIBCCoinsEnum() ?? IBCCoins.upylon,
      assetType: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kNftFormat, orElse: () => StringParam()).value.toAssetTypeEnum() ?? AssetType.Image,
      duration:
          recipe.entries.itemOutputs.firstOrNull?.longs.firstWhere((longKeyValue) => longKeyValue.key == kDuration, orElse: () => LongParam()).weightRanges.firstOrNull?.upper.toInt().toSeconds() ??
              "0",
      createdAt: createdAt,
      hashtags: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kHashtags, orElse: () => StringParam()).value ?? "",
      realWorld: recipe.entries.itemOutputs.firstOrNull?.strings.firstWhere((strKeyValue) => strKeyValue.key == kRealWorld, orElse: () => StringParam(key: kRealWorld, value: "false")).value == "true",
    );
  }

  static Future<NFT> fromItemID(String cookbookID, String itemID) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final item = await walletsStore.getItem(cookbookID, itemID);
    return NFT.fromItem(item!);
  }

  static Future<NFT> fromTradeByID(Int64 tradeID) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final trade = await walletsStore.getTradeByID(tradeID);
    return NFT.fromTrade(trade!);
  }

  static Future<NFT?> fromRecipeId(String cookbookId, String recipeId) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final recipeEither = await walletsStore.getRecipe(cookbookId, recipeId);

    if (recipeEither.isLeft()) {
      return null;
    }

    return NFT.fromRecipe(recipeEither.toOption().toNullable()!);
  }

  @override
  List<Object?> get props => [
        url,
        thumbnailUrl,
        name,
        description,
        denom,
        price,
        creator,
        owner,
        amountMinted,
        quantity,
        tradePercentage,
        cookbookID,
        recipeID,
        itemID,
        width,
        height,
        appType,
        tradeID,
        ownerAddress,
        ibcCoins,
        type,
        assetType,
        duration,
        fileSize,
        hashtags,
        createdAt,
        realWorld,
      ];
}
