import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import '../modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart';

enum FreeDrop { yes, no, unselected }

class Events extends Equatable {
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
  final List<PerksModel>? listOfPerks;
  final String isFreeDrops;
  final String cookbookID;
  final String step;
  final String denom;
  String ownerAddress = "";
  String owner = "";

  Events({
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
    this.listOfPerks,

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

    ///*
    this.ownerAddress = "",
    this.owner = '',
  });

  Future<String> getOwnerAddress() async {
    if (ownerAddress.isEmpty) {
      final walletsStore = GetIt.I.get<WalletsStore>();
      final cookbook = await walletsStore.getCookbookById(cookbookID);
      ownerAddress = cookbook?.creator ?? "";

      if (owner.isEmpty) {
        owner = await walletsStore.getAccountNameByAddress(ownerAddress);
      }
    }
    return ownerAddress;
  }

  factory Events.fromRecipe(Recipe recipe) {
    final Map<String, String> map = _extractAttributeValues(recipe.entries.itemOutputs[0].strings);

    final List<PerksModel> listOfPerks = [];
    jsonDecode(map[kPerks]!).map((jsonMap) {
      listOfPerks.add(PerksModel.fromJson(jsonMap as Map<String, dynamic>));
    }).toList();

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
      listOfPerks: listOfPerks,
      cookbookID: map[kCookBookId]!,
      recipeID: map[kRecipeId]!,
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

  static Future<Events?> eventFromRecipeId(String cookbookId, String recipeId) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final recipeEither = await walletsStore.getRecipe(cookbookId, recipeId);

    if (recipeEither.isLeft()) {
      return null;
    }

    return Events.fromRecipe(recipeEither.toOption().toNullable()!);
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

  factory PerksModel.fromJson(Map<String, dynamic> map) => PerksModel(name: map['name']!.toString(), description: map['description']!.toString());

  Map<String, String> toJson() {
    final Map<String, String> map = {};
    map['name'] = name;
    map['description'] = description;

    return map;
  }

  @override
  String toString() {
    return 'PerksModel{name: $name, description: $description}';
  }
}
