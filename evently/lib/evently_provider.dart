import 'dart:io';
import 'package:evently/main.dart';
import 'package:evently/models/denom.dart';
import 'package:evently/models/events.dart';
import 'package:evently/models/perks_model.dart';
import 'package:evently/models/picked_file_model.dart';
import 'package:evently/repository/repository.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/extension_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:pylons_sdk/low_level.dart';

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

  String get startDate => _startDate;
  String get endDate => _endDate;
  String get startTime => _startTime;
  String get endTime => _endTime;
  String get location => _location;
  String get description => _description;

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

  /// perks screen
  final List<PerksModel> _perks = [];
  int _selectedPerk = 0;

  List<PerksModel> get perks => _perks;

  int get selectedPerk => _selectedPerk;

  set setSelectedPerks(int val) {
    _selectedPerk = val;
    notifyListeners();
  }

  set setPerks(PerksModel perksModel) {
    _perks.add(perksModel);
    notifyListeners();
  }

  updatePerks(PerksModel perksModel, int index) {
    _perks[index] = perksModel;
    notifyListeners();
  }

  removePerks(int index) {
    _perks.removeAt(index);
    notifyListeners();
  }

  ///* price screen

  Denom _selectedDenom = Denom.availableDenoms.first;

  Denom get selectedDenom => _selectedDenom;

  List<Denom> supportedDenomList = Denom.availableDenoms;

  FreeDrop _isFreeDrop = FreeDrop.unselected;

  int _numberOfTickets = 0;
  int _price = 0;

  set setNumberOfTickets(int numberOfTickets) {
    _numberOfTickets = numberOfTickets;
    notifyListeners();
  }

  get numberOfTickets => _numberOfTickets;

  get isFreeDrop => _isFreeDrop;

  set setFreeDrop(FreeDrop freeDrop) {
    _isFreeDrop = freeDrop;
    notifyListeners();
  }

  set setPrice(int price) {
    _price = price;
    notifyListeners();
  }

  get price => _price;

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

  String currentUserName = "";
  bool stripeAccountExists = false;
  late Event event;
  String? _cookbookId;
  String _recipeId = "";

  bool showStripeDialog() => !stripeAccountExists && _selectedDenom.symbol == kUsdSymbol && isFreeDrop == FreeDrop.no;

  ///* this method is used to get the profile
  Future<SDKIPCResponse<Profile>> getProfile() async {
    final sdkResponse = await PylonsWallet.instance.getProfile();

    if (sdkResponse.success) {
      currentUserName = sdkResponse.data!.username;
      stripeAccountExists = sdkResponse.data!.stripeExists;

      supportedDenomList = Denom.availableDenoms.where((Denom e) => sdkResponse.data!.supportedCoins.contains(e.symbol)).toList();

      if (supportedDenomList.isNotEmpty && selectedDenom.symbol.isEmpty) {
        _selectedDenom = supportedDenomList.first;
      }
    }
    setHostName = currentUserName;

    return sdkResponse;
  }

  Future<bool> createRecipe({required Event event}) async {
    final scaffoldMessengerState = navigatorKey.getState();

    _cookbookId = repository.getCookbookId();

    final String savedUserName = repository.getCookBookGeneratorUsername();

    if (_cookbookId == null || isDifferentUserName(savedUserName)) {
      // create cookbook
      final isCookBookCreated = await createCookbook();

      if (isCookBookCreated) {
        // this delay is added to wait the transaction is settle
        // on the blockchain
        Future.delayed(const Duration(milliseconds: 800));
        // get device cookbook id
        _cookbookId = repository.getCookbookId();
        notifyListeners();
      } else {
        return false;
      }
    }

    _recipeId = repository.autoGenerateEventlyId();

    return Future.value(true);
  }

  /// send createCookBook tx message to the wallet app
  /// return true or false depending on the response from the wallet app
  Future<bool> createCookbook() async {
    _cookbookId = repository.autoGenerateCookbookId();
    final cookBook1 = Cookbook(
      creator: "",
      id: _cookbookId,
      name: cookbookName,
      description: cookbookDesc,
      developer: hostName,
      version: kVersionCookboox,
      supportEmail: supportedEmail,
      enabled: true,
    );

    final response = await PylonsWallet.instance.txCreateCookbook(cookBook1);
    if (response.success) {
      repository.saveCookBookGeneratorUsername(currentUserName);
      return true;
    }

    navigatorKey.showMsg(message: response.error);
    return false;
  }

  bool isDifferentUserName(String savedUserName) => currentUserName.isNotEmpty && savedUserName != currentUserName;
}
