class BackupData {
  String username;
  String mnemonic;

  BackupData({required this.username, required this.mnemonic});

  factory BackupData.fromJson(Map json) {
    return BackupData(
      username: json["username"].toString(),
      mnemonic: json["mnemonic"].toString(),
    );
  }
}
