abstract class Cipher {
  String encrypt({
    required String password,
    required String data,
  });

  String decrypt({
    required String password,
    required String encryptedData,
  });
}
