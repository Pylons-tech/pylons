import 'dart:async';
import 'package:evently/models/events.dart';
import 'package:evently/services/third_party_services/event_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 6, entities: [Events])
abstract class AppDatabase extends FloorDatabase {
  EventsDao get eventsDao;
}
