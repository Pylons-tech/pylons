import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/services/pigeons/pigeon.dart';
import 'package:pylons_wallet/model/nft.dart';

import '../../stores/wallet_store.dart';

class CollectionsApiImp extends CollectionsApi {

  @override
  Future<List<NFTMessage>> getCollection() async {

    final walletsStore = GetIt.I.get<WalletsStore>();
    final wallet = walletsStore.getWallets().value.last;
    final items = await walletsStore.getItemsByOwner(wallet.publicAddress);
    final message = <NFTMessage>[];

    if (items.isNotEmpty) {
      await Future.wait(items.map((item) async {
        final nft = await NFT.fromItem(item);
        message.add(NFTMessage(imageUrl: nft.url));
      }).toList());
    }

    return message;

  }
}
