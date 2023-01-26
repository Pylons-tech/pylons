import 'dart:core';

import "package:collection/collection.dart";
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';
import 'package:floor/floor.dart';
import 'package:pylons_sdk/low_level.dart';

import '../utils/enums.dart';

enum FreeDrop { yes, no, unselected }

@entity
class NFT extends Equatable {
  @primaryKey
  final int? id;
  final String url;

  final String thumbnailUrl;
  final String name;

  final String description;

  final String denom;

  final String price;

  final String creator;

  final String owner;

  final int amountMinted;

  final String quantity;

  final String tradePercentage;

  final String cookbookID;

  final String recipeID;
  final String itemID;

  final String width;
  final String height;

  final String appType;

  final String tradeID;

  final String ownerAddress;

  final String step;

  final String ibcCoins;

  final String isFreeDrop;
  final String type;

  final String assetType;

  final String duration;

  final String hashtags;

  final String fileName;

  final String fileSize;

  final String cid;
  final int dateTime;

  final bool isDialogShown;

  final bool isEnabled;

  final String fileExtension;

  const NFT({
    this.id,
    this.url = "",
    this.thumbnailUrl = "",
    this.name = "",
    this.description = "",
    this.denom = "",
    this.price = "0",
    this.type = "",
    this.creator = "",
    this.itemID = "",
    this.cookbookID = "",
    this.recipeID = "",
    this.owner = "",
    this.width = "",
    this.isFreeDrop = "unselected",
    this.height = "",
    this.tradePercentage = "0",
    this.amountMinted = 0,
    this.quantity = "0",
    this.fileSize = "0",
    this.appType = "",
    required this.ibcCoins,
    this.tradeID = "",
    required this.assetType,
    required this.step,
    this.duration = "",
    this.hashtags = "",
    this.fileName = "",
    this.cid = "",
    this.isEnabled = true,
    this.isDialogShown = false,
    this.dateTime = 0,
    this.ownerAddress = "",
    this.fileExtension = "",
  });

  factory NFT.fromRecipe(Recipe recipe) {
    final royalties = recipe.entries.itemOutputs.firstOrNull?.tradePercentage.fromBigInt().toInt().toString();
    return NFT(
      type: NftType.TYPE_RECIPE.name,
      recipeID: recipe.id,
      cookbookID: recipe.cookbookId,
      name: recipe.entries.itemOutputs.firstOrNull?.strings
              .firstWhere((strKeyValue) => strKeyValue.key == kName, orElse: () => StringParam())
              .value ??
          "",
      url: recipe.entries.itemOutputs.firstOrNull?.strings
              .firstWhere((strKeyValue) => strKeyValue.key == kNFTURL, orElse: () => StringParam())
              .value ??
          "",
      thumbnailUrl: recipe.entries.itemOutputs.firstOrNull?.strings
              .firstWhere((strKeyValue) => strKeyValue.key == kThumbnailUrl, orElse: () => StringParam())
              .value ??
          "",
      description: recipe.entries.itemOutputs.firstOrNull?.strings
              .firstWhere((strKeyValue) => strKeyValue.key == kDescription, orElse: () => StringParam())
              .value ??
          "",
      appType: recipe.entries.itemOutputs.firstOrNull?.strings
              .firstWhere((strKeyValue) => strKeyValue.key == kAppType, orElse: () => StringParam())
              .value ??
          "",
      creator: recipe.entries.itemOutputs.firstOrNull?.strings
              .firstWhere((strKeyValue) => strKeyValue.key == kCreator, orElse: () => StringParam())
              .value ??
          "",
      fileExtension: recipe.entries.itemOutputs.firstOrNull?.strings
              .firstWhere((strKeyValue) => strKeyValue.key == kFileExtension, orElse: () => StringParam())
              .value ??
          "",
      cid: recipe.entries.itemOutputs.firstOrNull?.strings
              .firstWhere((strKeyValue) => strKeyValue.key == kCID, orElse: () => StringParam())
              .value ??
          "",
      width: recipe.entries.itemOutputs.firstOrNull?.longs
              .firstWhere((longKeyValue) => longKeyValue.key == kWidth, orElse: () => LongParam())
              .weightRanges
              .firstOrNull
              ?.upper
              .toString() ??
          "0",
      height: recipe.entries.itemOutputs.firstOrNull?.longs
              .firstWhere((longKeyValue) => longKeyValue.key == kHeight, orElse: () => LongParam())
              .weightRanges
              .firstOrNull
              ?.upper
              .toString() ??
          "0",
      amountMinted: int.parse(recipe.entries.itemOutputs.firstOrNull?.amountMinted.toString() ?? "0"),
      quantity: recipe.entries.itemOutputs.firstOrNull?.quantity.toString() ?? "0",
      tradePercentage: royalties == null ? kNone : "$royalties%",
      price: recipe.coinInputs.firstOrNull?.coins.firstOrNull?.amount ?? "0",
      denom: recipe.coinInputs.firstOrNull?.coins.firstOrNull?.denom ?? "",
      ibcCoins: recipe.coinInputs.firstOrNull?.coins.firstOrNull?.denom ?? IBCCoins.upylon.name,
      assetType: recipe.entries.itemOutputs.firstOrNull?.strings
              .firstWhere((strKeyValue) => strKeyValue.key == kNftFormat, orElse: () => StringParam())
              .value ??
          AssetType.Image.name,
      duration: recipe.entries.itemOutputs.firstOrNull?.longs
              .firstWhere((longKeyValue) => longKeyValue.key == kDuration, orElse: () => LongParam())
              .weightRanges
              .firstOrNull
              ?.upper
              .toInt()
              .toSeconds() ??
          "0",
      step: "",
      isFreeDrop: "no",
      hashtags: recipe.entries.itemOutputs.firstOrNull?.strings
              .firstWhere((strKeyValue) => strKeyValue.key == kHashtags, orElse: () => StringParam())
              .value ??
          "",
      isEnabled: recipe.enabled,
    );
  }

  @override
  List<Object?> get props => [
        url,
        name,
        description,
        denom,
        price,
        type,
        creator,
        itemID,
        owner,
      ];

  @override
  String toString() {
    return 'NFT{id: $id, url: $url, thumbnailUrl: $thumbnailUrl, name: $name, description: $description, denom: $denom, price: $price, creator: $creator, owner: $owner, amountMinted: $amountMinted, quantity: $quantity, tradePercentage: $tradePercentage, cookbookID: $cookbookID, recipeID: $recipeID, itemID: $itemID, width: $width, height: $height, appType: $appType, tradeID: $tradeID, ownerAddress: $ownerAddress, step: $step, ibcCoins: $ibcCoins, isFreeDrop: $isFreeDrop, type: $type, assetType: $assetType, duration: $duration, hashtags: $hashtags, fileName: $fileName, cid: $cid, dateTime: $dateTime, isDialogShown: $isDialogShown, isEnabled: $isEnabled}';
  }
}

extension CreateRecipe on NFT {
  Recipe createRecipe({
    required String cookbookId,
    required String recipeId,
    required FreeDrop isFreeDrop,
    required String symbol,
    required List<String> hashtagsList,
    required String tradePercentage,
    required String price, 
  }) {
    return Recipe(
      cookbookId: cookbookId,
      id: recipeId,
      nodeVersion: Int64(1),
      name: name.trim(),
      description: description.trim(),
      version: kVersion,
      coinInputs: [
        if (isFreeDrop == FreeDrop.yes)
          CoinInput()
        else
          CoinInput(
            coins: [Coin(amount: price, denom: symbol)],
          )
      ],
      itemInputs: [],
      costPerBlock: Coin(denom: kUpylon, amount: costPerBlock),
      entries: EntriesList(
        coinOutputs: [],
        itemOutputs: [
          ItemOutput(
            id: kEaselNFT,
            doubles: [
              DoubleParam(
                key: kResidual,
                weightRanges: [
                  DoubleWeightRange(
                    lower: tradePercentage,
                    upper: tradePercentage,
                    weight: Int64(1),
                  )
                ],
              )
            ],
            longs: [
              LongParam(
                key: kQuantity,
                weightRanges: [
                  IntWeightRange(
                    lower: Int64(int.parse(quantity.replaceAll(",", "").trim())),
                    upper: Int64(int.parse(quantity.replaceAll(",", "").trim())),
                    weight: Int64(1),
                  )
                ],
              ),
              LongParam(key: kWidth, weightRanges: [_buildIntWeightRange(upperRange: width, lowerRange: width)]),
              LongParam(key: kHeight, weightRanges: [_buildIntWeightRange(upperRange: height, lowerRange: height)]),
              LongParam(
                  key: kDuration, weightRanges: [_buildIntWeightRange(upperRange: duration, lowerRange: duration)]),
            ],
            strings: [
              StringParam(key: kName, value: name.trim()),
              StringParam(key: kAppType, value: kEasel),
              StringParam(key: kDescription, value: description.trim()),
              StringParam(
                key: kHashtags,
                value: hashtagsList.join(kHashtagSymbol),
              ),
              StringParam(key: kNFTFormat, value: assetType),
              StringParam(key: kNFTURL, value: url),
              StringParam(key: kThumbnailUrl, value: thumbnailUrl),
              StringParam(key: kCreator, value: creator.trim()),
              StringParam(key: kFileExtension, value: fileExtension.trim()),
              StringParam(key: kCID, value: cid),
              StringParam(key: kFileSize, value: fileSize),
              StringParam(key: kRealWorld, value: "false"),
            ],
            mutableStrings: [],
            transferFee: [Coin(denom: kPylonSymbol, amount: transferFeeAmount)],
            tradePercentage: tradePercentage,
            tradeable: true,
            amountMinted: Int64(),
            quantity: Int64(int.parse(quantity.replaceAll(",", "").trim())),
          ),
        ],
        itemModifyOutputs: [],
      ),
      outputs: [
        WeightedOutputs(entryIds: [kEaselNFT], weight: Int64(1))
      ],
      blockInterval: Int64(),
      enabled: true,
      extraInfo: kExtraInfo,
    );
  }

  IntWeightRange _buildIntWeightRange({required String upperRange, required String lowerRange}) => IntWeightRange(
        lower: Int64(int.parse(lowerRange)),
        upper: Int64(int.parse(lowerRange)),
        weight: Int64(1),
      );
}
