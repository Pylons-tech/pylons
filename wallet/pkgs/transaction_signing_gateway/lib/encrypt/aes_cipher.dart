import 'package:encrypt/encrypt.dart';
import 'package:transaction_signing_gateway/encrypt/cipher.dart';

class AESCipher implements Cipher {
  @override
  String decrypt({required String password, required String encryptedData}) {
    final bundle = _EncryptedBundle.fromString(encryptedData);
    if (bundle == null) {
      throw ArgumentError('encrypted data has wrong format');
    }
    final encrypter = _fromPassword(password: password, salt: bundle.salt);
    return encrypter.decrypt(
      bundle.encryptedData,
      iv: bundle.iv,
    );
  }

  @override
  String encrypt({required String password, required String data}) {
    final iv = _iv();
    final salt = _salt();
    final encrypter = _fromPassword(password: password, salt: salt);
    return _EncryptedBundle(
      iv: iv,
      salt: salt,
      encryptedData: encrypter.encrypt(data, iv: iv),
    ).string;
  }

  IV _iv() => IV.fromSecureRandom(16);

  IV _salt() => IV.fromSecureRandom(32);

  Encrypter _fromPassword({required String password, required IV salt}) {
    final key = Key.fromUtf8(password).stretch(32, salt: salt.bytes, iterationCount: 500);
    return Encrypter(AES(key));
  }
}

class _EncryptedBundle {
  _EncryptedBundle({
    required this.iv,
    required this.salt,
    required this.encryptedData,
  });

  static const _delimiter = '|';
  final IV iv;
  final IV salt;

  final Encrypted encryptedData;

  static _EncryptedBundle? fromString(String str) {
    final split = str.split(_delimiter);
    if (split.length != 3) {
      return null;
    } else {
      return _EncryptedBundle(
        iv: IV.fromBase64(split[0]),
        salt: IV.fromBase64(split[1]),
        encryptedData: Encrypted.fromBase64(split[2]),
      );
    }
  }

  String get string => '${iv.base64}$_delimiter${salt.base64}$_delimiter${encryptedData.base64}';
}
