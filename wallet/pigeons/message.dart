import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigeon/pigeon.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_view_model.dart';

class NFT {
  final CachedNetworkImage image;

  NFT(this.image);
}

@FlutterApi()
abstract class CollectionsApi {
  List<NFT> getCollection(CollectionViewModel viewModel);
}