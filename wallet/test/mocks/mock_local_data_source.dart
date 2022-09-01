import 'package:pylons_wallet/model/pick_image_model.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/services/data_stores/local_data_store.dart';

class MockLocalDataSource extends LocalDataSource {
  @override
  Future<void> clearDataOnIosUnInstall() {
    throw UnimplementedError();
  }

  @override
  String getStripeAccountId() {
    throw UnimplementedError();
  }

  @override
  String getStripeToken() {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveStripeAccountId({required String accountId}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveStripeToken({required String token}) {
    throw UnimplementedError();
  }

  @override
  bool getStripeExistsOrNot() {
    throw UnimplementedError();
  }

  @override
  Future<void> saveStripeExistsOrNot({required bool isExists}) async {
    return;
  }

  @override
  String getDescription() {
    throw UnimplementedError();
  }

  @override
  String getEmail() {
    throw UnimplementedError();
  }

  @override
  String getImagePath(String uri) {
    throw UnimplementedError();
  }

  @override
  bool getIsBannerDark() {
    throw UnimplementedError();
  }

  @override
  Future<String> pickImageFromGallery(PickImageModel pickImageModel) {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveDescription(String description) {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveEmail(String email) {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveImage({required String key, required String imagePath}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveIsBannerDark({required bool isBannerDark}) {
    throw UnimplementedError();
  }

  @override
  bool getNotificationPreference() {
    throw UnimplementedError();
  }

  @override
  Future<String> saveImageInLocalDirectory(String imagePath) {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveNotificationsPreference({required bool notificationStatus}) {
    throw UnimplementedError();
  }

  @override
  Future<String> getMnemonics() {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveMnemonics(String mnemonics) {
    throw UnimplementedError();
  }

  @override
  Future<void> setApplicationDirectory() {
    throw UnimplementedError();
  }

  @override
  bool getLoginBiometric() {
    // TODO: implement getLoginBiometric
    throw UnimplementedError();
  }

  @override
  bool getSecurityBiometric() {
    // TODO: implement getSecurityBiometric
    throw UnimplementedError();
  }

  @override
  bool getTransactionBiometric() {
    // TODO: implement getTransactionBiometric
    throw UnimplementedError();
  }

  @override
  Future<bool> saveDefaultSecurityBiometric({required bool biometricEnabled}) {
    // TODO: implement saveDefaultSecurityBiometric
    throw UnimplementedError();
  }

  @override
  Future<bool> saveLoginBiometric({required bool biometricEnabled}) {
    // TODO: implement saveLoginBiometric
    throw UnimplementedError();
  }

  @override
  Future<bool> saveTransactionBiometric({required bool biometricEnabled}) {
    // TODO: implement saveTransactionBiometric
    throw UnimplementedError();
  }

  @override
  String getInitialLink() {
    // TODO: implement getInitialLink
    throw UnimplementedError();
  }

  @override
  bool saveInitialLink(String initialLink) {
    // TODO: implement saveInitialLink
    throw UnimplementedError();
  }

  @override
  String getNetworkEnvironmentPreference() {
    // TODO: implement getNetworkEnvironmentPreference
    throw UnimplementedError();
  }

  @override
  Future<bool> saveNetworkEnvironmentPreference(
      {required String networkEnvironment}) {
    // TODO: implement saveNetworkEnvironmentPreference
    throw UnimplementedError();
  }

  @override
  Future<bool> saveInviteeAddress({required String address}) {
    // TODO: implement saveInviteeAddress
    throw UnimplementedError();
  }

  @override
  String getInviteeAddress() {
    // TODO: implement getInviteeAddress
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTransactionFailureRecord(int id) {
    // TODO: implement deleteTransactionFailureRecord
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionManager>> getAllTransactionFailures() {
    // TODO: implement getAllTransactionFailures
    throw UnimplementedError();
  }

  @override
  Future<int> saveTransactionFailure(TransactionManager txManager) {
    // TODO: implement saveTransactionFailure
    throw UnimplementedError();
  }
}
