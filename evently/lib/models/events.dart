

import 'package:evently/evently_provider.dart';
import 'package:evently/utils/constants.dart';
import 'package:pylons_sdk/low_level.dart';
import 'package:fixnum/fixnum.dart';

class Event {
  Event({
    required this.eventName,
    required this.hostName,
    required this.thumbnail,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.description,
    required this.isFreeDrop,
    required this.numberOfTickets,
    required this.price,
    required this.listOfPerks,
  });

  final String eventName;

  final String hostName;

  final String thumbnail;

  final String startDate;

  final String endDate;

  final String startTime;

  final String endTime;

  final String location;

  final String description;

  final String isFreeDrop;

  final String numberOfTickets;

  final String price;

  final List<String> listOfPerks;


}



extension CreateRecipe on Event {
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
      name: eventName.trim(),
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
            id: kEventlyEvent,
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
                    lower: Int64(int.parse(numberOfTickets.replaceAll(",", "").trim())),
                    upper: Int64(int.parse(numberOfTickets.replaceAll(",", "").trim())),
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
      // extraInfo: kExtraInfo,
    );
  }


}
