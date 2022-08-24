import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pylons_wallet/model/pick_image_model.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/permission_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  /// This method save stripe token in the local storage
  /// Input: [token]  the stripe token that we need to save
  /// Output: [bool] indicates whether the operation is successful or not
  Future<bool> saveStripeToken({required String token});

  /// This method save stripe account id  in the local storage
  /// Input: [accountId]  the account key of the user stripe
  /// Output: [bool] indicates whether the operation is successful or not
  Future<bool> saveStripeAccountId({required String accountId});

  /// This method gets the  stripe token in the local storage
  /// Output: [String] the stripe token that has been saved
  String getStripeToken();

  /// This method gets the  stripe account id from the local storage
  /// Output: [String] the stripe account id  that has been saved
  String getStripeAccountId();

  /// This method will clear the data on IOS reinstall
  Future<void> clearDataOnIosUnInstall();

  /// This method will save the stripe exists or not
  /// Input : [isExists] tells whether the stripe exists or not
  Future<void> saveStripeExistsOrNot({required bool isExists});

  /// This method will get the stripe exists or not from local data store
  /// Output : [isExists] tells whether the stripe exists or not
  bool getStripeExistsOrNot();

  /// This method will pick image from the gallery
  /// Input : [pickImageModel] contains info regarding the image to be picked
  /// Output: [String] gives local image path
  Future<String> pickImageFromGallery(PickImageModel pickImageModel);

  /// This method will save the image in the local database
  /// Input: [key] against which the value will be saved, [imagePath] the path of the image
  /// Output: [bool] tells whether the operation is successful or not
  Future<bool> saveImage({required String key, required String imagePath});

  /// This method will get the image from the local database
  /// Input: [uri] against which the image is saved
  /// Output: [String] returns the path of the image
  String getImagePath(String uri);

  /// This method saves the boolean value that indicates whether the banner has a dark or light brightness value
  /// Input: [isBannerDark] contains the boolean value that was determine from the images brightness
  /// Output: if successful will return [bool] which tells whether the operation is successful or not
  Future<bool> saveIsBannerDark({required bool isBannerDark});

  /// This method gets the boolean value that indicates whether the banner has a dark or light brightness value
  /// Output: if successful will return [bool] indicating whether the banner is dark or light
  bool getIsBannerDark();

  /// This method will save email in the local database
  /// Input: [email] save email in the local database
  /// Output: [bool] tells whether the operation is successful or not
  Future<bool> saveEmail(String email);

  /// This method will get the email from the local database
  /// Output: [String] returns the email
  String getEmail();

  /// This method will save initialLink in the local database
  /// Input: [link] save initialLink in the local database
  /// Output: [bool] tells whether the operation is successful or not
  bool saveInitialLink(String initialLink);

  /// This method will get the initialLink from the local database
  /// Output: [String] return the link
  String getInitialLink();

  /// This method will save description in the local database
  /// Input: [description] save description in the local database
  /// Output: [bool] tells whether the operation is successful or not
  Future<bool> saveDescription(String description);

  /// This method will get the description from the local database
  /// Output: [String] returns the email
  String getDescription();

  /// This method will get the description from the local database
  /// Output: [bool] returns the notification preference
  bool getNotificationPreference();

  /// This method will save description in the local database
  /// Input: [notificationStatus] save notification in the database
  /// Output: [bool] tells whether the operation is successful or not
  Future<bool> saveNotificationsPreference({required bool notificationStatus});

  /// This method will save NetworkEnvironmentPreference in the local database
  /// Input : [networkEnvironment] is the network Environment preference of the user
  /// Output: if successful will return [String] which tells which network is selected
  /// else throw error
  Future<bool> saveNetworkEnvironmentPreference(
      {required String networkEnvironment});

  /// This method will return the selected network environment
  /// Output: if successful will return [String] NetworkEnvironment preference
  /// else throw error
  String getNetworkEnvironmentPreference();

  /// This method will save image in applications local directory
  /// Input: [imagePath] the path of the image
  /// Output: [String] the path of the saved image
  Future<String> saveImageInLocalDirectory(String imagePath);

  /// This method will save mnemonics in the local secure storage
  /// Input: [mnemonics] the mnemonics is saved.
  /// Output: [bool] tells whether the operation is successful or not
  Future<bool> saveMnemonics(String mnemonics);

  /// This method will save mnemonics in the local secure storage
  /// Output: return [mnemonics] that is saved.
  Future<String> getMnemonics();

  /// This method will set application directory in the cache
  Future<void> setApplicationDirectory();

  /// This method will save the default security biometric
  /// Input: [biometricEnabled] tells whether the biometric security feature should be enabled or not
  /// Output: returns true if everything successful
  Future<bool> saveDefaultSecurityBiometric({required bool biometricEnabled});

  /// This method will get the default security biometric
  /// Output : [bool] returns whether the biometric is enabled or not
  bool getSecurityBiometric();

  /// This method will save the login biometric
  /// Input: [biometricEnabled] tells whether the biometric security feature should be enabled or not
  /// Output: returns true if everything successful
  Future<bool> saveLoginBiometric({required bool biometricEnabled});

  /// This method will get the login biometric
  /// Output : [bool] returns whether the biometric is enabled or not
  bool getLoginBiometric();

  /// This method will save the transaction biometric
  /// Input: [biometricEnabled] tells whether the biometric security feature should be enabled or not
  /// Output: returns true if everything successful
  Future<bool> saveTransactionBiometric({required bool biometricEnabled});

  /// This method will get the transaction biometric
  /// Output : [bool] returns whether the biometric is enabled or not
  bool getTransactionBiometric();

  /// This method will save the invitee address
  /// Input: [address] the address of the user who had invited this user
  /// Output: [bool] tells whether ths operation is successful or not
  Future<bool> saveInviteeAddress({required String address});

  /// This method will return the saved invitee address if exists
  /// Output: [String] will return the address of invitee if saved else will give empty string
  String getInviteeAddress();
}

class LocalDataSourceImp implements LocalDataSource {
  final SharedPreferences sharedPreferences;
  final PermissionService permissionService;

  final ImagePicker picker;
  final FlutterSecureStorage flutterSecureStorage;

  static const iosOptions =
      IOSOptions(accessibility: IOSAccessibility.passcode);
  static const androidOptions =
      AndroidOptions(encryptedSharedPreferences: true);

  LocalDataSourceImp(
      {required this.sharedPreferences,
      required this.picker,
      required this.flutterSecureStorage,
      required this.permissionService});

  static String STRIPE_TOKEN_KEY = 'stripe_token_key';
  static String STRIPE_ACCOUNT_KEY = 'stripe_account_key';
  static String STRIPE_EXISTS = 'stripe_exists';
  static String EMAIL = 'email';
  static String IS_BANNER_DARK = 'is_banner_dark';
  static String DESCRIPTION = 'description';
  static String NOTIFICATION_PREFERENCE = 'notification';
  static String MNEMONIC = 'new_mnemonic';
  static String SECURITY_BIOMETRIC = 'security-biometric';
  static String LOGIN_BIOMETRIC = 'login-biometric';
  static String TRANSACTION_BIOMETRIC = 'transaction-biometric';
  static String APPLICATION_DIRECTORY = 'application_directory';
  static String INITIAL_LINK = 'initial_link';
  static String ENVIRONMENT_NETWORK = 'environment_network';
  static String INVITEE_ADDRESS = 'invitee_address';

  Map cacheContainer = {};

  @override
  Future<void> clearDataOnIosUnInstall() async {
    if (Platform.isAndroid) {
      return SynchronousFuture(null);
    }

    if ((sharedPreferences.getString('first_run') ?? "true") == "true") {
      await flutterSecureStorage.deleteAll();

      sharedPreferences.setString('first_run', "false");
    }
  }

  @override
  Future<bool> saveStripeToken({required String token}) {
    return sharedPreferences.setString(STRIPE_TOKEN_KEY, token);
  }

  @override
  String getStripeToken() {
    return sharedPreferences.getString(STRIPE_TOKEN_KEY) ?? '';
  }

  @override
  Future<bool> saveStripeAccountId({required String accountId}) {
    return sharedPreferences.setString(STRIPE_ACCOUNT_KEY, accountId);
  }

  @override
  String getStripeAccountId() {
    return sharedPreferences.getString(STRIPE_ACCOUNT_KEY) ?? '';
  }

  @override
  bool getStripeExistsOrNot() {
    return sharedPreferences.getBool(STRIPE_EXISTS) ?? false;
  }

  @override
  Future<void> saveStripeExistsOrNot({required bool isExists}) {
    return sharedPreferences.setBool(STRIPE_EXISTS, isExists);
  }

  @override
  Future<String> pickImageFromGallery(PickImageModel pickImageModel) async {
    final permissionStatus = await permissionService.status(Permission.photos);
    if (permissionStatus.isGranted || permissionStatus.isLimited) {
      final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: pickImageModel.maxWidth,
          maxHeight: pickImageModel.maxHeight,
          imageQuality: pickImageModel.imageQuality);
      return image?.path ?? '';
    }

    final afterPermissionStatus =
        await permissionService.request(Permission.photos);

    if (afterPermissionStatus.isGranted || permissionStatus.isLimited) {
      final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: pickImageModel.maxWidth,
          maxHeight: pickImageModel.maxHeight,
          imageQuality: pickImageModel.imageQuality);
      return image?.path ?? '';
    }

    throw 'permission_cant_get'.tr();
  }

  @override
  Future<bool> saveImage({required String key, required String imagePath}) {
    return sharedPreferences.setString(key, imagePath.split('/').last);
  }

  @override
  Future<bool> saveIsBannerDark({required bool isBannerDark}) {
    return sharedPreferences.setBool(IS_BANNER_DARK, isBannerDark);
  }

  @override
  bool getIsBannerDark() {
    return sharedPreferences.getBool(IS_BANNER_DARK) ?? true;
  }

  @override
  String getImagePath(String uri) {
    if (!cacheContainer.containsKey(APPLICATION_DIRECTORY)) {
      throw 'Application Directory not set';
    }
    final path = sharedPreferences.getString(uri) ?? '';

    if (path.isEmpty) {
      throw 'Application Directory not set';
    }

    return "${cacheContainer[APPLICATION_DIRECTORY]}/$path";
  }

  @override
  Future<bool> saveEmail(String email) {
    return sharedPreferences.setString(EMAIL, email);
  }

  @override
  String getEmail() {
    return sharedPreferences.getString(EMAIL) ?? '';
  }

  @override
  bool saveInitialLink(String initialLink) {
    cacheContainer.update(INITIAL_LINK, (v) => initialLink,
        ifAbsent: () => initialLink);
    return cacheContainer.containsValue(initialLink);
  }

  @override
  String getInitialLink() {
    return cacheContainer[INITIAL_LINK].toString();
  }

  @override
  String getDescription() {
    return sharedPreferences.getString(DESCRIPTION) ?? '';
  }

  @override
  Future<bool> saveDescription(String description) {
    return sharedPreferences.setString(DESCRIPTION, description);
  }

  @override
  bool getNotificationPreference() {
    return sharedPreferences.getBool(NOTIFICATION_PREFERENCE) ?? false;
  }

  @override
  Future<bool> saveNotificationsPreference(
      {required bool notificationStatus}) async {
    return sharedPreferences.setBool(
        NOTIFICATION_PREFERENCE, notificationStatus);
  }

  @override
  Future<String> saveImageInLocalDirectory(String imagePath) async {
    if (!cacheContainer.containsKey(APPLICATION_DIRECTORY)) {
      throw 'Application Directory not set';
    }

    final String path = cacheContainer[APPLICATION_DIRECTORY].toString();
    final image = File(imagePath);

    final File newImage =
        await image.copy('$path/${imagePath.split("/").last}');

    return newImage.path;
  }

  @override
  Future<String> getMnemonics() async {
    final mnemonic = await flutterSecureStorage.read(
        key: MNEMONIC, aOptions: androidOptions, iOptions: iosOptions);
    if (mnemonic == null) {
      throw CacheFailure("no_data_saved".tr());
    }
    return mnemonic;
  }

  @override
  Future<bool> saveMnemonics(String mnemonics) async {
    await flutterSecureStorage.write(
        key: MNEMONIC,
        value: mnemonics,
        aOptions: androidOptions,
        iOptions: iosOptions);
    return true;
  }

  @override
  Future<void> setApplicationDirectory() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    cacheContainer.putIfAbsent(APPLICATION_DIRECTORY, () => directory.path);
  }

  @override
  Future<bool> saveDefaultSecurityBiometric(
      {required bool biometricEnabled}) async {
    await sharedPreferences.setBool(SECURITY_BIOMETRIC, biometricEnabled);
    return true;
  }

  @override
  bool getSecurityBiometric() {
    return sharedPreferences.getBool(SECURITY_BIOMETRIC) ?? false;
  }

  @override
  bool getLoginBiometric() {
    return sharedPreferences.getBool(LOGIN_BIOMETRIC) ?? false;
  }

  @override
  Future<bool> saveLoginBiometric({required bool biometricEnabled}) {
    return sharedPreferences.setBool(LOGIN_BIOMETRIC, biometricEnabled);
  }

  @override
  bool getTransactionBiometric() {
    return sharedPreferences.getBool(TRANSACTION_BIOMETRIC) ?? false;
  }

  @override
  Future<bool> saveTransactionBiometric({required bool biometricEnabled}) {
    return sharedPreferences.setBool(TRANSACTION_BIOMETRIC, biometricEnabled);
  }

  @override
  String getNetworkEnvironmentPreference() {
    return sharedPreferences.getString(ENVIRONMENT_NETWORK) ?? "";
  }

  @override
  Future<bool> saveNetworkEnvironmentPreference(
      {required String networkEnvironment}) {
    return sharedPreferences.setString(ENVIRONMENT_NETWORK, networkEnvironment);
  }

  @override
  Future<bool> saveInviteeAddress({required String address}) async {
    await sharedPreferences.setString(INVITEE_ADDRESS, address);
    return true;
  }

  @override
  String getInviteeAddress() {
    return sharedPreferences.getString(INVITEE_ADDRESS) ?? '';
  }
}
