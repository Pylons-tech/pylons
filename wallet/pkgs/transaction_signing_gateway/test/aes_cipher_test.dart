import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_signing_gateway/encrypt/aes_cipher.dart';

void main() {
  group('AesCipher', () {
    const password = 'coolPassword123!';
    const testData = 'this is test data';
    final cipher = AESCipher();

    test('encrypting and decrypting works', () async {
      final encrypted = cipher.encrypt(password: password, data: testData);
      final decrypted = cipher.decrypt(password: password, encryptedData: encrypted);
      expect(testData, decrypted);
    });
    test('encrypting same data yields different result each time', () async {
      final cipher = AESCipher();

      final en1 = cipher.encrypt(password: password, data: testData);
      final en2 = cipher.encrypt(password: password, data: testData);
      expect(en1, isNot(equals(en2)));
      final dec1 = cipher.decrypt(password: password, encryptedData: en1);
      final dec2 = cipher.decrypt(password: password, encryptedData: en2);
      expect(dec1, equals(dec2));
    });
  });

  setUp(() {});
}
