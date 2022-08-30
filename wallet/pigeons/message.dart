import 'package:pigeon/pigeon.dart';

class NFT {
  final String imageUrl;

  NFT(this.imageUrl);
}

@FlutterApi()
abstract class CollectionsApi {
  List<NFT> getCollection();
}