import 'dart:io';
import 'package:evently/models/denom.dart';
import 'package:evently/models/picked_file_model.dart';
import 'package:evently/repository/repository.dart';
import 'package:evently/utils/constants.dart';
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

  ///* overview screen variable
  String _eventName = '';
  String _hostName = '';
  File? _thumbnail;
  bool _isOverviewEnable = false;

  File? get thumbnail => _thumbnail;
  String get eventName => _eventName;
  String get hostName => _hostName;
  bool get isOverviewEnable => _isOverviewEnable;

  set setEventName(String value) {
    _eventName = value;
    checkIsOverEnable();
    notifyListeners();
  }

  set setHostName(String value) {
    _hostName = value;
    checkIsOverEnable();
    notifyListeners();
  }

  set setThumbnail(File? file) {
    _thumbnail = file;
    checkIsOverEnable();
    notifyListeners();
  }

  set setOverviewEnable(bool value) {
    _isOverviewEnable = value;
    notifyListeners();
  }

  checkIsOverEnable() {
    setOverviewEnable = thumbnail != null && eventName.length >= kMinEventName && hostName.length >= kMinHostName;
  }

  ///* detail screen
  String _startDate = "";
  String _endDate = "";
  String _startTime = "";
  String _endTime = "";
  String _location = "";
  String _description = "";
  bool _isDetailEnable = false;

  String get startDate => _startDate;
  String get endDate => _endDate;
  String get startTime => _startTime;
  String get endTime => _endTime;
  String get location => _location;
  String get description => _description;
  bool get isDetailEnable => _isDetailEnable;

  set setStartDate(String value) {
    _startDate = value;
    notifyListeners();
  }

  set setEndDate(String value) {
    _endDate = value;
    notifyListeners();
  }

  set setStartTime(String value) {
    _startTime = value;
    notifyListeners();
  }

  set setEndTime(String value) {
    _endTime = value;
    notifyListeners();
  }

  set setLocation(String value) {
    _location = value;
    notifyListeners();
  }

  set setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  set isDetailEnable(bool value) {
    _isDetailEnable = value;
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

  void pickThumbnail() async {
    final pickedFile = await repository.pickFile();

    final result = pickedFile.getOrElse(
      () => PickedFileModel(
        path: "",
        fileName: "",
        extension: "",
      ),
    );

    if (result.path.isEmpty) return;
    setThumbnail = File(result.path);
  }
}
