import 'package:floor/floor.dart';

import '../../../../model/favorites.dart';

@dao
abstract class FavoritesDao {
  @Query('SELECT * FROM FavoritesModel ORDER BY dateTime DESC')
  Future<List<FavoritesModel>> getAllFailuresEntries();

  @insert
  Future<int> insertFavorites(FavoritesModel favoritesModel);

  @Query('DELETE FROM FavoritesModel WHERE id = :id')
  Future<void> delete(int id);
}