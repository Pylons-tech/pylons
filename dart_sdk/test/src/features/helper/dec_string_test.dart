import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_sdk/src/features/helper/dec_string.dart';

void main() {
  test('string to dec', () {
    expect(1, DecString.doubleFromDecString('100000000000000000'));
    expect(0.1, DecString.doubleFromDecString('10000000000000000'));
    expect(0.01, DecString.doubleFromDecString('1000000000000000'));
    expect(0.00000000000000001, DecString.doubleFromDecString('1'));
  });
  test('dec to string', () {
    expect('100000000000000000', DecString.decStringFromDouble(1));
    expect('10000000000000000', DecString.decStringFromDouble(0.1));
    expect('1000000000000000', DecString.decStringFromDouble(0.01));
    expect('1', DecString.decStringFromDouble(0.00000000000000001));
  });

  test('should throw error when amount is greater than Max', () {
    expect(() => DecString.doubleFromDecString('9999999999999999999'),
        throwsA(isA<Exception>()));
  });
}
