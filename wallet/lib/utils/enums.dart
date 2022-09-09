enum AssetType { Audio, Image, Video, ThreeD, Pdf }

enum NftType {
  TYPE_RECIPE,
  TYPE_ITEM,
  TYPE_TRADE,
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
  // StripePayout,
  AppleInAppCoinsRequest,
  GoogleInAppCoinsRequest,
  BuyProduct,
  Unknown
}

enum TransactionStatus {
  Success,
  Failed,
  Undefined
}
