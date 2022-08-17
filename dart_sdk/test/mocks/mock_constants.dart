import 'package:fixnum/fixnum.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import 'package:pylons_sdk/src/generated/pylons/execution.pb.dart';

var MOCK_COOKBOOK = '''{
  "creator": "pylo1akzpu26f36pgxr636uch8evdtdjepu93v5y9s2",
  "id": "$MOCK_COOKBOOK_ID",
  "name": "Legend of the Undead Dragon",
  "description": "Cookbook for running pylons recreation of LOUD",
  "developer": "Pylons Inc",
  "version": "$MOCK_VERSION",
  "supportEmail": "alex@shmeeload.xyz",
  "enabled": true
}''';

var MOCK_RECIPE = Recipe(
    cookbookId: MOCK_COOKBOOK_ID,
    id: MOCK_RECIPE_ID,
    nodeVersion: MOCK_NODE_VERSION,
    name: "LOUD's Wooden sword lv1 buy recipe",
    description: 'this recipe is used to buy wooden sword lv1.',
    costPerBlock: Coin(denom: 'upylon', amount: '1000000'),
    version: MOCK_VERSION,
    coinInputs: [],
    itemInputs: [],
    entries: EntriesList(coinOutputs: [], itemOutputs: [
      ItemOutput(
        id: 'copper_sword_lv1',
        doubles: [],
        longs: [],
        strings: [],
        mutableStrings: [],
        transferFee: [],
        tradePercentage: DecString.decStringFromDouble(0.1),
        tradeable: true,
      ),
    ], itemModifyOutputs: []),
    outputs: [
      WeightedOutputs(entryIds: ['copper_sword_lv1'], weight: Int64(1))
    ],
    blockInterval: Int64(0),
    enabled: false,
    extraInfo: 'extraInfo');

var MOCK_TRADE = Trade(
  creator: MOCK_CREATOR,
  id: Int64(20211207),
  coinInputs: [],
  itemInputs: [],
  coinOutputs: [],
  itemOutputs: [
    ItemRef(cookbookId: MOCK_COOKBOOK_ID, itemId: MOCK_ITEM_ID),
  ],
  extraInfo: 'extraInfo',
  receiver: '',
  tradedItemInputs: [],
);

const String MOCK_COOKBOOK_ID = 'cookbookLOUD';
const String MOCK_ITEM_ID = 'item_id';
const String MOCK_RECIPE_ID = 'RecipeId';
const String MOCK_RECIPE_NAME = 'recipe name';
const String MOCK_OWNER = 'pyloabs8112932012asjdahk33';
const String MOCK_VERSION = 'v0.0.1';
const String MOCK_HOST = 'example';
const String MOCK_ERR_ = 'example';
const String MOCK_USERNAME = 'Jawad';
const String MOCK_ERR_CODE = 'Something went wrong';
const String MOCK_EXECUTION_ID = 'executionid';
const String MOCK_RECIPE_VERSION = 'v0.1.3';
Int64 MOCK_NODE_VERSION = Int64(1);
const String MOCK_CREATOR = 'pylo1akzpu26f36pgxr636uch8evdtdjepu93v5y9s2';
const int MOCK_PRICE = 10000;
const bool MOCK_STRIPE_EXISTS = false;

Cookbook MOCK_COOK_BOOK_OBJECT = Cookbook(
    creator: '',
    id: MOCK_COOKBOOK_ID,
    name: 'Legend of the Undead Dragon',
    description: 'Cookbook for running pylons recreation of LOUD',
    developer: 'Pylons Inc',
    version: 'v0.0.1',
    supportEmail: 'alex@shmeeload.xyz',
    enabled: true);

Item MOCK_ITEM = Item(
  owner: '',
  cookbookId: MOCK_COOKBOOK_ID,
  id: MOCK_ITEM_ID,
  nodeVersion: MOCK_NODE_VERSION,
  doubles: [],
  longs: [],
  strings: [],
);

ItemRef MOCK_ITEM_REF = ItemRef(
  cookbookId: MOCK_COOKBOOK_ID,
  itemId: MOCK_ITEM_ID,
);

Execution MOCK_EXECUTION = Execution(
  creator: MOCK_OWNER,
  id: MOCK_EXECUTION_ID,
  cookbookId: MOCK_COOKBOOK_ID,
  recipeVersion: MOCK_RECIPE_VERSION,
  nodeVersion: MOCK_NODE_VERSION,
);

Profile MOCK_USER_INFO_MODEL = Profile(
    username: MOCK_USERNAME,
    stripeExists: MOCK_STRIPE_EXISTS,
    items: [],
    address: MOCK_OWNER,
    coins: [],
    supportedCoins: ['upylon', 'uatom']);
