import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/models/events.dart';
import 'package:evently/services/third_party_services/database.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/date_utils.dart';
import 'package:evently/utils/failure/failure.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  /// This method will generate the cookbook id for the easel app
  /// Output: [String] the id of the cookbook which will contains all the NFTs.
  Future<String> autoGenerateCookbookId();

  /// This method will save the username of the cookbook generator
  /// Input: [username] the username of the user who created the cookbook
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveCookBookGeneratorUsername(String username);

  /// This method will get the already created cookbook from the local database
  /// Output: [String] if the cookbook already exists return cookbook else return null
  String? getCookbookId();

  /// This method will get the username of the cookbook generator
  /// Output: [String] returns whether the operation is successful or not
  String getCookBookGeneratorUsername();

  /// This method will generate easel Id for the NFT
  /// Output: [String] the id of the NFT that is going to be added in the recipe
  String autoGenerateEventlyId();

  /// This method will get the artist name
  /// Output: [String] returns whether the operation is successful or not
  String getHostName();

  /// This method will save the artist name
  /// Input: [name] the name of the artist which the user want to save
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveHostName(String name);

  /// This method will get the drafts List from the local database
  /// Output: [List][NFT] returns  the List of drafts
  Future<List<Events>> getAllEvents();

  /// This method will delete draft from the local database
  /// Input: [recipeID] the id of the draft which the user wants to delete
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> deleteEvents(int id);

  /// This method will save the draft of the NFT
  /// Input: [Events] the draft that will will be saved in database
  /// Output: [int] returns id of the inserted document
  Future<int> saveEvents(Events events);
}

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl extends LocalDataSource {
  LocalDataSourceImpl({
    required this.sharedPreferences,
    required this.database,
  });

  final SharedPreferences sharedPreferences;
  final AppDatabase database;

  /// auto generates cookbookID string and saves into local storage
  /// returns cookbookId
  @override
  Future<String> autoGenerateCookbookId() async {
    final String cookbookId = "Evently_CookBook_auto_cookbook_${getFullDateTime()}";
    await sharedPreferences.setString(kCookbookId, cookbookId);
    return cookbookId;
  }

  @override
  Future<bool> saveCookBookGeneratorUsername(String username) async {
    await sharedPreferences.setString(kUsername, username);
    return true;
  }

  /// gets cookbookId from local storage
  ///return String or null
  @override
  String? getCookbookId() {
    return sharedPreferences.getString(kCookbookId);
  }

  @override
  String getCookBookGeneratorUsername() {
    return sharedPreferences.getString(kUsername) ?? '';
  }

  /// auto generates easelID string
  /// returns easelId
  @override
  String autoGenerateEventlyId() {
    final String cookbookId = "Evently_Recipe_auto_recipe_${getFullDateTime()}";
    return cookbookId;
  }

  @override
  String getHostName() {
    return sharedPreferences.getString(kHostName) ?? '';
  }

  @override
  Future<bool> saveHostName(String name) async {
    await sharedPreferences.setString(kHostName, name);
    return true;
  }

  @override
  Future<List<Events>> getAllEvents() async {
    try {
      return await database.eventsDao.findAllEvents();
    } catch (e) {
      throw CacheFailure(LocaleKeys.get_error.tr());
    }
  }

  @override
  Future<bool> deleteEvents(int id) async {
    try {
      await database.eventsDao.delete(id);
      return true;
    } catch (e) {
      throw CacheFailure(LocaleKeys.delete_error.tr());
    }
  }

  @override
  Future<int> saveEvents(Events events) async {
    try {
      final result = await database.eventsDao.insertEvents(events);
      return result;
    } catch (e) {
      throw LocaleKeys.save_error.tr();
    }
  }
}
