import 'package:fixnum/fixnum.dart';
import 'package:pylons_wallet/model/stripe_get_login_based_address.dart';
import 'package:pylons_wallet/model/stripe_update_account_request.dart';
import 'package:pylons_wallet/model/transaction.dart';
import 'package:pylons_wallet/modules/Pylonstech.pylons.pylons/module/export.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_trace_model.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:transaction_signing_gateway/model/transaction_hash.dart';

TransactionHash MOCK_TRANSACTION = const TransactionHash(hash: '64CFE19786363B8C6AB10D865A5C570C3999AB0B95E5723BE584F574FC58F99E');

String MOCK_USERNAME = "Jawad";
String SENDER_APP = 'Sending app';

List<TransactionHistory> MOCK_TRANSACTIONS_HISTORY = [
  TransactionHistory(
      recipeId: "LOUDGetCharacter1",
      address: "pylo1fhvaknqx2ngyltz2qzychlm75cyp4tkh09d539",
      amount: "10upylon",
      cookbookId: "cookbookLOUD1",
      createdAt: 1654508506,
      transactionType: "NFTSELL",
      transactionTypeEnum: TransactionType.values.byName("NFTSELL"),
      ibcCoin: IBCCoins.upylon,
      txID: "txID"),
  TransactionHistory(
      address: "pylo12rzzd8nwxzrh28l6hexm2snuylldyht9cvj28c",
      cookbookId: "",
      recipeId: "",
      amount: "1000ubedrock",
      createdAt: 1655890906,
      transactionType: "RECEIVE",
      transactionTypeEnum: TransactionType.values.byName("RECEIVE"),
      ibcCoin: IBCCoins.uatom,
      txID: "txID"),
  TransactionHistory(
      address: "pylo1fhvaknqx2ngyltz2qzychlm75cyp4tkh09d539",
      cookbookId: "",
      recipeId: "",
      amount: "10upylon",
      createdAt: 1654508506,
      transactionType: "SEND",
      transactionTypeEnum: TransactionType.values.byName("SEND"),
      ibcCoin: IBCCoins.upylon,
      txID: "txID"),
];

String MOCK_COOKBOOK = """
{
  "creator": "pylo1akzpu26f36pgxr636uch8evdtdjepu93v5y9s2",
  "ID": "$MOCK_COOKBOOK_ID",
  "name": "Legend of the Undead Dragon",
  "nodeVersion": "v0.1.3",
  "description": "Cookbook for running pylons recreation of LOUD",
  "developer": "Pylons Inc",
  "version": "v0.0.1",
  "supportEmail": "alex@shmeeload.xyz",
  "costPerBlock": {"denom":  "upylon", "amount":  "1000000"},
  "enabled": true
}""";

String MOCK_RECIPE = """
{
  "cookbookID": "$MOCK_COOKBOOK_ID",
  "ID": "$MOCK_RECIPE_ID",
  "name": "Test NFT v3",
  "description": " A simple test recipe to be executed",
  "version": "v1.0.0",
  "coinInputs": [
    {
      "coins": [
        {
          "denom": "upylon",
          "amount": "350"
        }
      ]
    }
  ],
  "itemInputs": [],
  "entries": {
    "coinOutputs": [],
    "itemOutputs": [
      {
        "ID": "How_do_you_do_turn_this_on",
        "doubles": [
          {
            "key": "Residual",
            "weightRanges": [
              {
                "lower": "2000000000000000000",
                "upper": "2000000000000000000",
                "weight": 1
              }
            ]
          }
        ],
        "longs": [
          {
            "key": "Quantity",
            "weightRanges": [
              {
                "lower": 34,
                "upper": 34,
                "weight": 1
              }
            ]
          },
          {
            "key": "Width",
            "weightRanges": [
              {
                "lower": 960,
                "upper": 960,
                "weight": 1
              }
            ]
          },
          {
            "key": "Height",
            "weightRanges": [
              {
                "lower": 1280,
                "upper": 1280,
                "weight": 1
              }
            ]
          }
        ],
        "strings": [
          {
            "key": "Name",
            "value": "How do you do turn this on"
          },
          {
            "key": "App_Type",
            "value": "Avatar"
          },
          {
            "key": "Description",
            "value": "This is NFT Description for Test "
          },
          {
            "key": "NFT_URL",
            "value": "https://i.imgur.com/QechbvX.jpg"
          },
          {
            "key": "Currency",
            "value": "upylon"
          },
          {
            "key": "Price",
            "value": "450"
          },
          {
            "key": "Creator",
            "value": "NFT Studio"
          }
        ],
        "mutableStrings": [],
        "transferFee": [{"denom": "upylon",
          "amount": "10"
        }],
        "tradePercentage": "100000000000000000",
        "amountMinted": 0,
        "quantity": 30,
        "tradeable": true
      }
    ],
    "itemModifyOutputs": []
  },
  "outputs": [
    {
      "entryIDs": [
        "How_do_you_do_turn_this_on"
      ],
      "weight": 1
    }
  ],
  "blockInterval": 1,
  "enabled": true
}""";

const String MOCK_COOKBOOK_ID = 'cookbookLOUD';

const String MOCK_STRIPEURL = '';
const String MOCK_STRIPEPUBKEY = '';
const String MOCK_ADDRESS = 'pylo18238123823kjhgda7w1';
const String MOCK_RECIPE_ID = 'recipeid';
const String MOCK_ITEM_ID = 'itemId';
const String MOCK_EXECUTION_ID = 'executionId';
const String MOCK_ERROR = 'SOMETHING_WENT_WRONG';
const String MOCK_RECIPE_VERSION = 'recipe version';
const String MOCK_NODE_VERSION = 'node version';
const String MOCK_MNEMONIC = "laundry number match ring spatial surround gadget rally teach second cover crucial";

const String MOCK_TOKEN = 'tokenXYZ';
const String SIGNATURE = 'signature';

const String MOCK_ACCOUNT_LINK = 'mock_account_link';
const String MOCK_ACCOUNT = 'mock_account';
const bool MOCK_STRIPE_ACCOUNT_EXISTS = true;

StripeUpdateAccountRequest MOCK_STRIPE_UPDATE_ACCOUNT_REQUEST = StripeUpdateAccountRequest(Address: MOCK_ADDRESS, Token: MOCK_TOKEN, Signature: SIGNATURE);
StripeGetLoginBasedOnAddressRequest MOCK_STRIPE_LOGIN_BASED_ADDRESS_REQUEST = StripeGetLoginBasedOnAddressRequest(MOCK_ADDRESS);

Item MOCK_ITEM = Item(
  owner: '',
  cookbookId: MOCK_COOKBOOK_ID,
  id: MOCK_ITEM_ID,
  nodeVersion: Int64(1),
  doubles: [],
  longs: [],
  strings: [],
);

Execution MOCK_EXECUTION = Execution(
  creator: MOCK_ADDRESS,
  id: MOCK_EXECUTION_ID,
  cookbookId: MOCK_COOKBOOK_ID,
  recipeVersion: MOCK_RECIPE_VERSION,
  nodeVersion: Int64(1),
);

BaseEnv MOCK_BASE_ENV = BaseEnv()
  ..setEnv(
      lcdUrl: '',
      grpcUrl: '',
      lcdPort: '9090',
      grpcPort: '9090',
      ethUrl: '',
      faucetUrl: '',
      stripeUrl: '',
      stripePubKey: '',
      stripeTestEnv: false,
      stripeCallbackUrl: '',
      stripeCallbackRefreshUrl: "",
      chainId: 'pylons-testnet-2',
      ibcTraceUrl: "",
      mongoUrl: '',
      skus: '[]', isIosStripeEnabled: false);

IBCTraceModel MOCK_IBC_TRACE_MODEL = IBCTraceModel(denomTrace: DenomTrace(baseDenom: IBCCoins.ujunox, path: ''), ibcHash: '64CFE19786363B8C6AB10D865A5C570C3999AB0B95E5723BE584F574FC58F99E');
