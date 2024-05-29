enum AssetType { Audio, Image, Video, ThreeD, Pdf }

enum NftType {
  TYPE_RECIPE,
  TYPE_ITEM,
  TYPE_TRADE,
}

extension NftTypePar on dynamic {
  NftType toNFTTypeEnum() {
    return NftType.values.firstWhere((e) => e.toString() == 'NftType.$this', orElse: () => NftType.TYPE_ITEM);
  }
}

enum Orientation {
  Orientation_SE,
  Orientation_NE,
  Orientation_NW,
  Orientation_SW,
}

enum TransactionTypeEnum {
  GeneratePaymentReceipt,
  BuyNFT,
  AppleInAppCoinsRequest,
  GoogleInAppCoinsRequest,
  BuyProduct,
  Unknown,
  BuyEvent,
}

enum TransactionStatus {
  Success,
  Failed,
  Undefined
}
