import 'package:evently/utils/date_utils.dart';
import 'package:injectable/injectable.dart';

abstract class LocalDataSource {
  /// This method will generate Evently Id for the Event
  /// Output: [String] the id of the Event that is going to be added in the recipe
  String autoGenerateEventlyId();
}

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl extends LocalDataSource {
  @override
  String autoGenerateEventlyId() {
    final String cookbookId = "Event_Recipe_auto_recipe_${getFullDateTime()}";
    return cookbookId;
  }
}
