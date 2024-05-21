import 'package:equatable/equatable.dart';
import 'package:evently/utils/enums.dart';
import 'package:floor/floor.dart';
import 'package:pylons_sdk/low_level.dart';
import 'package:fixnum/fixnum.dart';

@entity
class Events extends Equatable {
  @primaryKey
  final int? id;
  final String recipeID;
  final String eventName;
  final String hostName;
  final String thumbnail;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String location;
  final String description;
  final String numberOfTickets;
  final String price;
  final String listOfPerks;
  final String isFreeDrops;
  final String cookbookID;
  final String step;
  final String denom;

  const Events({
    this.id,

    ///* overview data
    this.eventName = '',
    this.hostName = '',
    this.thumbnail = '',

    ///* details
    this.startDate = '',
    this.endDate = '',
    this.startTime = '',
    this.endTime = '',
    this.location = '',
    this.description = '',

    ///* perks
    this.listOfPerks = '',

    ///* price
    this.numberOfTickets = '0',
    this.price = '',
    this.isFreeDrops = 'unselected',
    this.denom = '',

    ///* other
    this.cookbookID = '',
    this.recipeID = '',

    ///* for tracking where its save as draft
    this.step = '',
  });

  factory Events.fromRecipe(Recipe recipe) {
    Map<String, String> map = _extractAttributeValues(recipe.entries.itemOutputs[0].strings);
    return Events(
      eventName: map[kEventName]!,
      hostName: map[kEventHostName]!,
      thumbnail: map[kThumbnail]!,
      startDate: map[kStartDate]!,
      endDate: map[kEndDate]!,
      startTime: map[kStartTime]!,
      endTime: map[kEndTime]!,
      location: map[kLocation]!,
      description: map[kDescription]!,
      numberOfTickets: map[kNumberOfTickets]!,
      price: map[kPrice]!,
      listOfPerks: map[kPerks]!,
      step: '',
    );
  }

  static Map<String, String> _extractAttributeValues(List<StringParam> attributes) {
    final Map<String, String> attributeValues = {};
    for (final attribute in attributes) {
      switch (attribute.key) {
        case kEventName:
        case kEventHostName:
        case kThumbnail:
        case kStartDate:
        case kEndDate:
        case kStartTime:
        case kEndTime:
        case kLocation:
        case kDescription:
        case kNumberOfTickets:
        case kPrice:
        case kPerks:
        case kFreeDrop:
        case kCookBookId:
        case kRecipeId:
          attributeValues[attribute.key] = attribute.value;
          break;
        default:
          continue;
      }
    }

    return attributeValues;
  }

  @override
  List<Object?> get props =>
      [eventName, hostName, thumbnail, startDate, endDate, startTime, endTime, location, description, numberOfTickets, price, listOfPerks, isFreeDrops, cookbookID, recipeID, step];

  @override
  String toString() {
    return 'Event{eventName: $eventName, hostName: $hostName, thumbnail: $thumbnail, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, location: $location, description: $description, numberOfTickets: $numberOfTickets, price: $price, listOfPerks: $listOfPerks, isFreeDrop: $isFreeDrops, cookbookID: $cookbookID, recipeID: $recipeID, step: $step}';
  }
}

extension CreateRecipe on Events {
  Recipe createRecipe({
    required String cookbookId,
    required String recipeId,
    required FreeDrop isFreeDrop,
    required String symbol,
    required List<PerksModel> perksList,
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
            doubles: [],
            longs: [],
            strings: [
              StringParam(key: kEventName, value: eventName.trim()),
              StringParam(key: kEventHostName, value: hostName.trim()),
              StringParam(key: kThumbnail, value: thumbnail.trim()),
              StringParam(key: kStartDate, value: startDate.trim()),
              StringParam(key: kEndDate, value: endDate.trim()),
              StringParam(key: kStartTime, value: startTime.trim()),
              StringParam(key: kEndTime, value: endTime.trim()),
              StringParam(key: kLocation, value: location.trim()),
              StringParam(key: kDescription, value: description.trim()),
              StringParam(key: kNumberOfTickets, value: numberOfTickets.trim()),
              StringParam(key: kPrice, value: price.trim()),
              StringParam(key: kPerks, value: listOfPerks.trim()),
              StringParam(key: kFreeDrop, value: isFreeDrops),
              StringParam(key: kCookBookId, value: cookbookID),
              StringParam(key: kRecipeId, value: recipeID),
            ],
            mutableStrings: [],
            transferFee: [Coin(denom: kPylonSymbol, amount: transferFeeAmount)],
            tradeable: true,
            amountMinted: Int64(),
          ),
        ],
        itemModifyOutputs: [],
      ),
      outputs: [
        WeightedOutputs(entryIds: [kEventlyEvent], weight: Int64(1))
      ],
      blockInterval: Int64(),
      enabled: true,
      extraInfo: kExtraInfo,
    );
  }
}

/// Event String keys
const kEventName = "kEventName";
const kEventHostName = "kEventHostName";
const kThumbnail = "kThumbnail";
const kStartDate = "kStartDate";
const kEndDate = "kEndDate";
const kStartTime = "kStartTime";
const kEndTime = "kEndTime";
const kLocation = "kLocation";
const kDescription = "kDescription";
const kPerks = "kPerks";
const kNumberOfTickets = "kNumberOfTickets";
const kPrice = "kPrice";
const kFreeDrop = "kFreeDrop";
const kRecipeId = "kRecipeId";
const kCookBookId = "kCookBookId";
const kVersion = "v0.2.0";
const kUpylon = "upylon";
const kPylonSymbol = 'upylon';
const transferFeeAmount = '1';
const kEventlyEvent = "Evently_Event";
const kExtraInfo = "extraInfo";
const costPerBlock = '0';

class PerksModel {
  PerksModel({required this.name, required this.description});

  final String name;
  final String description;

  factory PerksModel.updateName({required String name, required PerksModel perksModel}) => PerksModel(
        name: name,
        description: perksModel.description,
      );

  factory PerksModel.updateDescription({required String description, required PerksModel perksModel}) => PerksModel(
        name: perksModel.name,
        description: description,
      );

  factory PerksModel.fromJson(Map<String, dynamic> map) => PerksModel(name: map['name'] ?? '', description: map['description'] ?? '');

  Map<String, String> toJson() {
    Map<String, String> map = {};
    map['name'] = name;
    map['description'] = description;

    return map;
  }

  @override
  String toString() {
    return 'PerksModel{name: $name, description: $description}';
  }
}
