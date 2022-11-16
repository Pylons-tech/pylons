// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/enums.dart';

NFT MOCK_NFT = NFT(
  id:2,
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
  price: "5.0"
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

NFT MOCK_PRICED_Video_NFT = NFT(
  id: 1,
  name: "This is my video NFT",
  height: "2400",
  description: "Please purchas my video NFT",
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
  assetType: AssetType.Video.name,
  step: UploadStep.assetUploaded.name,
  price: "5.0",
);

NFT MOCK_PRICED_AUDIO_NFT = NFT(
  id: 1,
  name: "This is my Audio NFT",
  height: "2400",
  description: "Please Buy my Audio NFT",
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
  assetType: AssetType.Audio.name,
  step: UploadStep.assetUploaded.name,
  price: "5.0",
);

NFT MOCK_PRICED_PDF_NFT = NFT(
  id: 1,
  name: "This is my PDF NFT",
  height: "2400",
  description: "Please Buy my PDF NFT",
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
  assetType: AssetType.Pdf.name,
  step: UploadStep.assetUploaded.name,
  price: "5.0",
);

NFT MOCK_PRICED_3D_NFT = NFT(
  id: 1,
  name: "This is my 3D Model NFT",
  height: "2400",
  description: "Please Buy my 3D Model NFT",
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
  assetType: k3dText,
  step: UploadStep.assetUploaded.name,
  price: "5.0",
);
const String MOCK_ARTIST_NAME = "Ahmad Hassan";
const MOCK_DESCRIPTION =
    "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia molestiae quas vel sint commodi repudianda , eaque rerum! Provident similique accusantium nemo autem. Veritatis";
const MOCK_NFT_NAME = "This is my video Nft";
const MOCK_ROYALTIES = "20";
const MOCK_NO_OF_ENTITIES = "50";
const MOCK_PRICE = "50";

CollectionType MOCK_COLLECTION_TYPE = CollectionType.draft;
