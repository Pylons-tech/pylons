import 'package:pigeon/pigeon.dart';

class NFTMessage {
  final String imageUrl;

  NFTMessage(this.imageUrl);
}

@FlutterApi()
abstract class CollectionsApi {
  @async
  List<NFTMessage> getCollection();
}
