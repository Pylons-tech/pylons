import 'package:evently/models/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class EventHubViewModel extends ChangeNotifier {
  final List<Events> _eventPublishedList = [];

  List<Events> get eventPublishedList => _eventPublishedList;

  void updatePublishedEventList({required Events nft}) {}
}
