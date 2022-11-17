import 'package:floor/floor.dart';

import '../../../../model/favorites.dart';

@dao
abstract class FavoritesDao {
  @Query('SELECT * FROM FavoritesModel ORDER BY dateTime DESC')
  Future<List<FavoritesModel>> getAll();

  @insert
  Future<int> insertFavorites(FavoritesModel favoritesModel);

  @Query('DELETE FROM FavoritesModel WHERE id = :id')
  Future<void> delete(String id);

  @Query('DELETE  FROM FavoritesModel')
  Future<void> deleteAll();
}
