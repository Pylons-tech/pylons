import 'package:evently/models/events.dart';
import 'package:floor/floor.dart';

@dao
abstract class EventsDao {
  @Query('SELECT * FROM events ORDER BY dateTime DESC')
  Future<List<Events>> findAllEvents();

  @Query('SELECT * FROM events WHERE id = :id')
  Future<Events?> findEventsById(int id);

  @insert
  Future<int> insertEvents(Events events);

  @Query('DELETE FROM events WHERE id = :id')
  Future<void> delete(int id);
}
