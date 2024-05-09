import 'dart:io';

import 'package:evently/models/denom.dart';
import 'package:evently/repository/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

enum FreeDrop { yes, no, unselected }

@LazySingleton()
class EventlyProvider extends ChangeNotifier {
  EventlyProvider({
    required this.repository,
  });

  final Repository repository;

  TextEditingController eventNameController = TextEditingController();
  TextEditingController hostNameController = TextEditingController();
  File? _thumbnail;

  File? get thumbnail => _thumbnail;

  void setThumbnail(File? file) {
    _thumbnail = file;
    notifyListeners();
  }

  Denom _selectedDenom = Denom.availableDenoms.first;

  Denom get selectedDenom => _selectedDenom;

  List<Denom> supportedDenomList = Denom.availableDenoms;

  TextEditingController priceController = TextEditingController();

  FreeDrop isFreeDrop = FreeDrop.no;

  void setSelectedDenom(Denom value) {
    _selectedDenom = value;
    notifyListeners();
  }
}
