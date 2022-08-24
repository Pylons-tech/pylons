import 'package:easel_flutter/models/denom.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should have all the available denoms', () {
    for (Denom denom in Denom.availableDenoms) {
      if (denom.name == "Pylon") {
        expect(denom.symbol, kPylonSymbol);
      }

      if (denom.name == "USD") {
        expect(denom.symbol, kUsdSymbol);
      }

      if (denom.name == "Atom") {
        expect(denom.symbol, kAtomSymbol);
      }

      if (denom.name == "EEur") {
        expect(denom.symbol, kEuroSymbol);
      }

      if (denom.name == "Agoric") {
        expect(denom.symbol, kAgoricSymbol);
      }
    }
  });
}
