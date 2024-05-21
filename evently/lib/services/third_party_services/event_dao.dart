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
  Future<void> updateNFTFromDetail(
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
  Future<void> updateNFTFromPerks(
    String listOfPerks,
    int id,
    String step,
  );

  @Query('UPDATE events SET numberOfTickets = :numberOfTickets, price = :price, isFreeDrops = :isFreeDrops   WHERE id = :id')
  Future<void> updateNFTFromPrice(
    int id,
    String numberOfTickets,
    String price,
    String isFreeDrops,
  );
}
