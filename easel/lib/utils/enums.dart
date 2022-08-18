enum IBCCoins {
  urun,
  ujunox,
  none,
  ujuno,
  upylon,
  ustripeusd,
  eeur,
  uatom,
  weth_wei
}

enum NftType {
  TYPE_RECIPE,
  TYPE_ITEM,
  TYPE_TRADE,
}

enum AssetType { Audio, Image, Video, ThreeD, Pdf }

enum UploadStep { assetUploaded, descriptionAdded, priceAdded, none }

extension ToUploadStepPar on String {
  UploadStep toUploadStepEnum() {
    return UploadStep.values.firstWhere((e) {
      return e.toString().toLowerCase() == 'UploadStep.$this'.toLowerCase();
    }, orElse: () => UploadStep.none); //return null if not found
  }
}
