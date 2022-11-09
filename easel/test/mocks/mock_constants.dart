// ignore_for_file: non_constant_identifier_names

import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/utils/enums.dart';

NFT MOCK_NFT = NFT(
  name: "This is my Image NFT",
  height: "2400",
  description: "Please Buy my Image NFT",
  width: "1080",
  url: "https://proxy.pylons.tech/ipfs/bafkreihzxrk7rpxmih3wr6o5kccxpfyjneg7rbgkpmdflvwyd63geaiaby",
  recipeID: "Easel_Recipe_auto_recipe_2022_08_31_154526_206",
  duration: "0:0",
  cookbookID: "Easel_CookBook_auto_cookbook_2022_08_31_152836_312",
  appType: "easel",
  creator: "Ahmad",
  fileSize: "90.12KB",
  itemID: "DtnxAS8L4pf",
  owner: "abd",
  ibcCoins: IBCCoins.upylon.name,
  assetType: AssetType.Image.name,
  step: UploadStep.assetUploaded.name,
);

NFT MOCK_PRICED_NFT = NFT(
  id: 1,
  name: "This is my Image NFT",
  height: "2400",
  description: "Please Buy my Image NFT",
  width: "1080",
  url: "https://proxy.pylons.tech/ipfs/bafkreihzxrk7rpxmih3wr6o5kccxpfyjneg7rbgkpmdflvwyd63geaiaby",
  recipeID: "Easel_Recipe_auto_recipe_2022_08_31_154526_206",
  duration: "0:0",
  cookbookID: "Easel_CookBook_auto_cookbook_2022_08_31_152836_312",
  appType: "easel",
  creator: "Ahmad",
  fileSize: "90.12KB",
  itemID: "DtnxAS8L4pf",
  owner: "abd",
  ibcCoins: IBCCoins.upylon.name,
  assetType: AssetType.Image.name,
  step: UploadStep.assetUploaded.name,
  price: "5.0",
);


CollectionType MOCK_COLLECTION_TYPE = CollectionType.draft;