import 'package:floor/floor.dart';

@entity
class FavoritesModel {
  @primaryKey
  final int dateTime;
  final String id;
  final String cookbookId;
  final String type;
  

  FavoritesModel({required this.id, required this.cookbookId, required this.type, required this.dateTime});

  @override
  String toString() {
    return 'FavoritesModel{dateTime: $dateTime, id: $id, cookbookId: $cookbookId, type: $type}';
  }
}
