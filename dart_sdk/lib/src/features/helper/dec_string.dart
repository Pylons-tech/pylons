library pylons_flutter_dec_string;

/// Very rough compatibility functions for Cosmos' decimal types.
///
/// TODO: This is a temporary solution to make working with decimals easier, but
/// it is not a full port of the Cosmos decimal types, and should be deprecated upon
/// the completion of such.
class DecString {
  static const PRECISION = 18;
  static const MAX = 999999999999999999;
  static const ONE = 100000000000000000.0;

  /// Outputs a string containing a fixed-precision value of 18 places for the input double.
  static String decStringFromDouble(double f) {
    return (f * ONE).toStringAsPrecision(PRECISION).split('.').first;
  }

  /// Outputs a double containing the value represented by the input fixed-precision string of up to 18 places.
  static double doubleFromDecString(String f) {
    var i = int.parse(f);
    if (i > MAX) {
      throw Exception('$i requires more than $PRECISION places of precision');
    }
    return i / ONE;
  }
}
