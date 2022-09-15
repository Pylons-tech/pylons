import 'package:pigeon/pigeon.dart';


class NFTMessage {
  final String imageUrl;

  NFTMessage(this.imageUrl);
}

@HostApi()
abstract class MessageUtil {
  List<NFTMessage> getCollection();
}

@FlutterApi()
abstract class CollectionsApi {
  @async
  List<NFTMessage> getCollection();
}
