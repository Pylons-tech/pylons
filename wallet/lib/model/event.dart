import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/client/pylons/recipe.pb.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';

class Events extends Equatable {
  const Events({
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

  @override
  List<Object?> get props => [eventName, hostName, thumbnail, startDate, endDate, startTime, endTime, location, description, isFreeDrop, numberOfTickets, price];

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

  factory Events.fromRecipe(Recipe recipe) {
    final map = _extractAttributeValues(recipe.entries.itemOutputs[0].strings);

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
      isFreeDrop: '',
      numberOfTickets: map[kNumberOfTickets]!,
      price: map[kPrice]!,
      listOfPerks: [],
    );
  }

  static Future<Events?> fromRecipeId(String cookbookId, String recipeId) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final recipeEither = await walletsStore.getRecipe(cookbookId, recipeId);

    if (recipeEither.isLeft()) {
      return null;
    }

    return Events.fromRecipe(recipeEither.toOption().toNullable()!);
  }
}
