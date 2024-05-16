import 'package:equatable/equatable.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/models/perks_model.dart';
import 'package:evently/utils/constants.dart';
import 'package:pylons_sdk/low_level.dart';
import 'package:fixnum/fixnum.dart';

class Event extends Equatable {
  const Event({
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
    required this.listOfPerks,

    ///* price
    this.numberOfTickets = '0',
    this.price = '',
    this.isFreeDrop = 'unselected',
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
  final String numberOfTickets;
  final String price;
  final List<String> listOfPerks;
  final String isFreeDrop;

  factory Event.fromRecipe(Recipe recipe) {
    Map<String, String> map = _extractAttributeValues(recipe.entries.itemOutputs[0].strings);

    return Event(
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
      listOfPerks: [],
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
        case kPerks:
        case kNumberOfTickets:
        case kPrice:
          attributeValues[attribute.key] = attribute.value;
          break;
        default:
          continue;
      }
    }

    return attributeValues;
  }

  @override
  List<Object?> get props => [eventName, hostName, thumbnail, startDate, endDate, startTime, endTime, location, description, numberOfTickets, price];
}

extension CreateRecipe on Event {
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
              StringParam(key: kPerks, value: kPerks.trim()),
              StringParam(key: kNumberOfTickets, value: numberOfTickets.trim()),
              StringParam(key: kPrice, value: price.trim()),
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
