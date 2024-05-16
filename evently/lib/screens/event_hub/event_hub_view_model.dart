import 'package:evently/models/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class EventHubViewModel extends ChangeNotifier {
  List<Events> _eventPublishedList = [];

  List<Events> get eventPublishedList => _eventPublishedList;

  List<Events> _eventForSaleList = [];

  List<Events> get eventForSaleList => _eventForSaleList;

  set setEventForSaleList(List<Events> nftForSale) {
    _eventForSaleList = nftForSale;
    notifyListeners();
  }

  set setEventPublishList(List<Events> events) {
    _eventPublishedList = events;
    notifyListeners();
  }

  void updatePublishedEventList({required Events events}) {
    _eventPublishedList.add(events);
    _eventForSaleList.add(events);
    notifyListeners();
  }
}
