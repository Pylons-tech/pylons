import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/utils/constants.dart';

void main() {
  test('IBC Coins dollar conversion test', () {
    const ibcCoins = IBCCoins.ustripeusd;
    expect(ibcCoins.getCoinValueBasedOnDollar((0.1 * kBigIntBase).toString()), "0.10");
    expect(ibcCoins.getCoinValueBasedOnDollar((0.01 * kBigIntBase).toString()), "0.01");
    expect(ibcCoins.getCoinValueBasedOnDollar((3 * kBigIntBase).toString()), "3.00");
    expect(ibcCoins.getCoinValueBasedOnDollar((9.23 * kBigIntBase).toString()), "9.23");
    expect(ibcCoins.getCoinValueBasedOnDollar((75 * kBigIntBase).toString()), "75.00");
    expect(ibcCoins.getCoinValueBasedOnDollar((99.67 * kBigIntBase).toString()), "99.67");
    expect(ibcCoins.getCoinValueBasedOnDollar((999 * kBigIntBase).toString()), "999");
    expect(ibcCoins.getCoinValueBasedOnDollar((1000 * kBigIntBase).toString()), "1,000");
    expect(ibcCoins.getCoinValueBasedOnDollar((9967 * kBigIntBase).toString()), "9,967");
  });
}
