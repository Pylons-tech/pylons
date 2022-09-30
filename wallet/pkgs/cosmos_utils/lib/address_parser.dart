import 'package:bech32/bech32.dart';
import 'package:hex/hex.dart';

@Deprecated("Use cosmos-node-client's `Account` class instead")
String bech32ToHex(String address) {
  const bech32codec = Bech32Codec();
  final bech32address = bech32codec.decode(address);

  return HEX.encode(_convertBits(bech32address.data, 5, 8, false));
}

@Deprecated("Use cosmos-node-client's `Account` class instead")
List<int> _convertBits(List<int> data, int from, int to, bool pad) {
  var acc = 0;
  var bits = 0;
  final result = <int>[];
  final maxV = (1 << to) - 1;

  for (final v in data) {
    if (v < 0 || (v >> from) != 0) {
      throw Exception();
    }
    acc = (acc << from) | v;
    bits += from;
    while (bits >= to) {
      bits -= to;
      result.add((acc >> bits) & maxV);
    }
  }

  if (pad) {
    if (bits > 0) {
      result.add((acc << (to - bits)) & maxV);
    }
  } else if (bits >= from) {
    throw InvalidPadding('illegal zero padding');
  } else if (((acc << (to - bits)) & maxV) != 0) {
    throw InvalidPadding('non zero');
  }

  return result;
}
