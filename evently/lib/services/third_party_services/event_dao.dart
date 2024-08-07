import 'package:evently/models/events.dart';
import 'package:floor/floor.dart';

@dao
abstract class EventsDao {
  @Query('SELECT * FROM events')
  Future<List<Events>> findAllEvents();

  @Query('SELECT * FROM events WHERE id = :id')
  Future<Events?> findEventsById(int id);

  @insert
  Future<int> insertEvents(Events events);

  @Query('DELETE FROM events WHERE id = :id')
  Future<void> delete(int id);

  @Query('UPDATE events SET startDate = :startDate, endDate= :endDate, startTime = :startTime, endTime = :endTime,location = :location, description = :description, step = :step WHERE id = :id')
  Future<void> updateEventFromDetail(
    String startDate,
    String endDate,
    String startTime,
    String endTime,
    String location,
    String description,
    int id,
    String step,
  );

  @Query('UPDATE events SET listOfPerks = :listOfPerks, step = :step WHERE id = :id')
  Future<void> updateEventFromPerks(
    String listOfPerks,
    int id,
    String step,
  );

  @Query('UPDATE events SET numberOfTickets = :numberOfTickets, price = :price, isFreeDrops = :isFreeDrops, denom = :denom, step = :step WHERE id = :id')
  Future<void> updateEventFromPrice(
    int id,
    String numberOfTickets,
    String price,
    String isFreeDrops,
    String denom,
    String step,
  );

  @Query(
      'UPDATE events SET eventName = :eventName, hostName = :hostName, thumbnail = :thumbnail, startDate = :startDate, endDate = :endDate, startTime = :startTime, endTime = :endTime, location = :location, description = :description, numberOfTickets = :numberOfTickets, price = :price, listOfPerks = :listOfPerks, isFreeDrops = :isFreeDrops, step = :step, denom = :denom WHERE id = :id')
  Future<void> updateEvent(
    int id,
    String step,
    String eventName,
    String hostName,
    String thumbnail,
    String startDate,
    String endDate,
    String startTime,
    String endTime,
    String location,
    String description,
    String listOfPerks,
    String numberOfTickets,
    String price,
    String isFreeDrops,
    String denom,
  );
}
