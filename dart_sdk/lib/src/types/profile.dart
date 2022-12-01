import 'package:fixnum/fixnum.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

/// Wrapper object for the user's profile and associated state.
class Profile {
  /// The DateTime this profile was retrieved. Use it to make decisions about when to retrieve the profile again.
  final DateTime asOf = DateTime.now();

  /// The user's address.
  final String address;

  /// The user's human-readable username.
  final String username;

  /// Map containing all of the user's coins.
  final Map<String, Int64> coins;

  /// List containing all of the user's items.
  final List<Item> items;

  /// Does the user have Stripe enabled?
  final bool hasStripe;

  Profile(this.address, this.username, this.coins, this.items, this.hasStripe);

  /// Retrieves the current state of the profile on chain, or null if no profile exists.
  static Future<Profile?> get() async {
    var ll = await PylonsWallet.instance.getProfile();
    if (ll.success) {
      final b = <String, Int64>{};
      ll.data!.coins.forEach((element) {
        // this is hacky, I don't love the shuffle but if we're not supporting fractional values there's no reason to support decimal, right?
        b[element.denom] = Int64.parseInt(element.amount.value.toString());
      });
      final i = <Item>[];
      ll.data!.items.forEach((element) {
        i.add(Item.fromItem(element));
      });
      return Profile(ll.data!.address, ll.data!.username, Map.unmodifiable(b),
          List.unmodifiable(i), ll.data!.stripeExists);
    } else {
      return null;
    }
  }
}
