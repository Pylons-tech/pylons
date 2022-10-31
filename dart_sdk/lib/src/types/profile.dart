import 'package:fixnum/fixnum.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

class Profile {
  final DateTime asOf = DateTime.now();
  final String address;
  final String username;
  final Map<String, Int64> getBalances;
  final List<Item> items;
  final bool hasStripe;

  Profile(this.address, this.username, this.getBalances, this.items, this.hasStripe);

  static Future<Profile?> get () async {
    var ll = await PylonsWallet.instance.getProfile();
    if (ll.success) {
      final b = <String, Int64>{};
      ll.data!.coins.forEach((element) {
        // this is hacky, I don't love the shuffle but if we're not supporting fractional values there's no reason to support decimal, right?
        b[element.denom] = Int64.parseInt(element.amount.value.toString());
      });
      final i = <Item>[];
      ll.data!.items.forEach((element) {
        i.add(Item(element));
      });
      return Profile(ll.data!.address, ll.data!.username, Map.unmodifiable(b), List.unmodifiable(i), ll.data!.stripeExists);
    } else {
      return null;
    }
  }
}