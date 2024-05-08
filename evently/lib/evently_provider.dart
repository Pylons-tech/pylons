import 'package:evently/models/denom.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

enum FreeDrop { yes, no, unselected }

@lazySingleton
class EventlyProvider extends ChangeNotifier {
  Denom _selectedDenom = Denom.availableDenoms.first;

  Denom get selectedDenom => _selectedDenom;

  List<Denom> supportedDenomList = [];

  TextEditingController priceController = TextEditingController();

  FreeDrop isFreeDrop = FreeDrop.unselected;

  void setSelectedDenom(Denom value) {
    _selectedDenom = value;
    notifyListeners();
  }
}
