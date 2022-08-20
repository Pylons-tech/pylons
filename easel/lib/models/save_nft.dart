import 'package:easel_flutter/models/nft.dart';

class SaveNft {
  final int? id;
  final String? nftName;
  final String? nftDescription;
  final String? creatorName;
  final String? tradePercentage;
  final String? price;
  final String? quantity;
  final String? denomSymbol;
  final FreeDrop? isFreeDrop;
  final String? step;
  final String? hashtags;
  final int? dateTime;

  SaveNft({
    this.id,
    this.isFreeDrop,
    this.price,
    this.tradePercentage,
    this.quantity,
    this.denomSymbol,
    this.step,
    this.creatorName,
    this.nftDescription,
    this.nftName,
    this.hashtags,
    this.dateTime,
  });
}
