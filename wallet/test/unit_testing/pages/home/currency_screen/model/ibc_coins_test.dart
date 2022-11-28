import 'package:flutter_test/flutter_test.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/utils/constants.dart';

void main(){

  test('IBC Coins dollar conversion test', () {
    const ibcCoins = IBCCoins.ustripeusd;
    expect(ibcCoins.getCoinWithProperDenomination((3*kBigIntBase).toString()), "3.00");
    expect(ibcCoins.getCoinWithProperDenomination((9.23*kBigIntBase).toString()), "9.23");
    expect(ibcCoins.getCoinWithProperDenomination((75*kBigIntBase).toString()), "75.00");
    expect(ibcCoins.getCoinWithProperDenomination((99.67*kBigIntBase).toString()), "99.67");
    expect(ibcCoins.getCoinWithProperDenomination((999*kBigIntBase).toString()), "999");
    expect(ibcCoins.getCoinWithProperDenomination((1000*kBigIntBase).toString()), "1,000");
    expect(ibcCoins.getCoinWithProperDenomination((9967*kBigIntBase).toString()), "9,967");
  });

}