# Introduction

This document is basic developer CLI tutorial for beginners.

There is more information on [Pylons Spec](https://github.com/Pylons-tech/pylons/tree/main/docs/spec).

Important points in pylons are:


- **Cookbook**: This is a principal concept in pylons. It is the container for your application recipes. An example is a game. And to build recipes and items, you need to have cookbooks.
- **recipe**: these execute commands to create, modify, and trade items on the blockchain. Can be created solely by devs or exposed to users for use. Recipes can be used to get result of some action between items and characters. Every action related to items are taken by recipes.
- **item**: Items are NFTs. It can be items in original games. Items will have properties in the format of Double, String, Integer etc. Characters can be created as items either.
- **trade**: this functionality enables accounts to trade their coins themselves. Trade includes items - items trading, coins - coins trading and mixed trading.


It's helpful if you know something about `cosmos-sdk` as Pylons is based on [cosmos-sdk](https://cosmos.network/sdk).

# Setup Local Environment
  
Refer to the [technical setup page](../TECHNICAL-SETUP.md) for instructions.

- Go version: Download and [install](https://golang.org/doc/install) the lastest Go verision 
- Pylonsd version: Download the latest version/[tagged release](https://github.com/Pylons-tech/pylons/releases)

         ensure GOPATH is set properly to point to the go directory of your Go installation: GOPATH = $HOME/go
         ensure PATH is set properly to point to the bin folder of your Go installation: PATH = $GOPATH/bin
         pylonsd binary(link above or from 'make install' on repo clone/source) should be put in Go's bin folder

- Starport version: Download and install the latest version of [starport](https://docs.starport.network/guide/install.html)

## Start pylons 

If running locally,

  1. Download the source from the latest pylons release
  2. unzip and cd into pylons
  3. Run starport chain serve
 ```shell
   $ starport chain serve
   ```

If not running locally or if you wish to start the pylons daemon without starport, Download binary files for `pylonsd` from link above and run ```make install``` on it which will install the binary into GOPATH/bin. Alternatively you can clone the source, checkout the latest version and run ```make install```. After this, run the following commands.

1. Initialize the pylons directories and create the local genesis file with the correct
   chain-id

   ```shell
   $ pylonsd init <moniker-name> --chain-id=pylons-testnet
   ```
2. Set the keyring to test 
  
  ```shell
   $ pylonsd config keyring-backend test
   ```

3. Create local key pairs in the Keybase with key name: `jack`. You can create more accounts for trading between accounts later.

   ```shell
   $ pylonsd keys add <key-name> 

   ```
   We recommend that you save the mnemonic generated to be able to recover your account in the future if it gets lost.  

4. Add your account to your local genesis file with a given amount and the key you
   just created. 

   ```shell
   $ pylonsd add-genesis-account $(pylonsd keys show <key-name> -a) 1000000ubedrock
   ```

5. Create the gentx ()

   ```shell
   $ pylonsd gentx <key-name> 1000000ubedrock --moniker="<moniker-name>" --pubkey $(pylonsd tendermint show-validator) --chain-id=pylons-testnet --output-document ./gentxs/<moniker-name>.json                    
   ```

6. run collect Gentx
   ```shell
   $ pylonsd collect gentx
   ```

7. replace all occurrences of "stake" in the genesis file with "ubedrock" in the genesis in .pylons/config/genesis.json unless you are using a pre-configured genesis/genesis from another source e.g a central genesis for a network, that has already done this.

8. start pylons
   ```shell
   pylonsd start
   ```

# CLI commands

Now you are ready to use cli commands. Open a new terminal window other than the pylons daemon/chain terminal window. Try to run the pylonsd command.

if you have problems running your daemon check the section above on GOPATH and PATH settings and ensure they are set properly.


```
pylonsd
```
This command will give you the overall help for all available commands in pylonsd.
The result should be like the following.

```
Stargate Pylons App

Usage:
  pylonsd [command]

Available Commands:
  add-genesis-account Add a genesis account to genesis.json
  collect-gentxs      Collect genesis txs and output a genesis.json file
  config              Create or query an application CLI configuration file
  debug               Tool for helping with debugging your application
  export              Export state to JSON
  gentx               Generate a genesis tx carrying a self delegation
  help                Help about any command
  init                Initialize private validator, p2p, genesis, and application configuration files
  keys                Manage your application's keys
  migrate             Migrate genesis to a specified target version
  query               Querying subcommands
  start               Run the full node
  status              Query remote node for status
  tendermint          Tendermint subcommands
  tx                  Transactions subcommands
  unsafe-reset-all    Resets the blockchain database, removes address book files, and resets data/priv_validator_state.json to the genesis state
  validate-genesis    validates the genesis file at the default location or at the location passed as an arg
  version             Print the application binary version information

Flags:
  -h, --help                help for pylonsd
      --home string         directory for config and data (default "/Users/conwuliri/.pylons")
      --log_format string   The logging format (json|plain) (default "plain")
      --log_level string    The logging level (trace|debug|info|warn|error|fatal|panic) (default "info")
      --trace               print out full stack trace on errors

Use "pylonsd [command] --help" for more information about a command.
```

Now let's move forward with some important cli commands one by one.

Some of the pylonsd cli commands require user password for keyring-backend. If you don't set keyring backend like `pylonsd keys show jack` it will default keyring as `os` and will require your computer password. But in the end, keys are not stored in os backend, hence, it will not show you the same key that is created right now.

If you set `--keyring-backend=test` flag, it uses the test keyring which does not require password. On our tutorial, we will be using test keyring for most of the commands.  
 
  
  To set this keyring once, run
  ```
   pylonsd config keyring-backend test
   ```

### Local keys

`pylonsd keys` command will let you add or view local keys in the chain.

- Add your first local key
  ```
  pylonsd keys add jack 
  ```

  You can replace the local key that is set `jack` in the example with any key you want.

  This command will create a local key with the name given as the argument. The result will be like following.

  ```
  name: jack
  type: local
  address: pylo1wp5p47qng6ua5tz03t5s6u2ej7hylrpva9q28r
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"A1iZOha1tMg7nhz+ZhXcc+3zzujqZcAyHEBKOoY2fqfr"}'
  mnemonic: ""


  Important: write this mnemonic phrase in a safe place.
  It is the only way to recover your account if you ever forget your password.

  oval doctor mosquito mad cash season life survey type grace apple measure glad dismiss huge citizen virtual lens survey smart vivid sssss ccccc vvvv
  ```

  The `address` value `pylo1wp5p47qng6ua5tz03t5s6u2ej7hylrpva9q28r` will be used for the other cli commands.

- Show the local key
  ```
  pylonsd keys show jack 
  ```
  This will show the info of the local key `jack` that is just added.
  The result will be like following.
  ```
  name: jack
  type: local
  address: pylo1wp5p47qng6ua5tz03t5s6u2ej7hylrpva9q28r
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"A1iZOha1tMg7nhz+ZhXcc+3zzujqZcAyHEBKOoY2fqfr"}'
  mnemonic: ""
  ```

- List all the keys available
  ```
  pylonsd keys list 
  ```
  This command will list all the local keys that are available in the chain.
  The result will be like the following.
  ```
  [
  name: alice
  type: local
  address: pylo1zhu40grs2wshfyytrd40y5y5ldpkar22tf2k29
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"Ape6Byykvfn16bo0tMV8bEdDv2udMnTN3QmVgqt4Sarj"}'
  mnemonic: ""
  name: bob
  type: local
  address: pylo1rl69433ge3gtj5c9h922j5mu6dms64nqyktscn
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"A8MqFprIKamNdMDJwUGPvpQRqYuhWJW4gng//mXlvQGD"}'
  mnemonic: ""
  name: jack
  type: local
  address: pylo1wp5p47qng6ua5tz03t5s6u2ej7hylrpva9q28r
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"A1iZOha1tMg7nhz+ZhXcc+3zzujqZcAyHEBKOoY2fqfr"}'
  mnemonic: ""
  ]
  ```

### Create an account on chain

We already added key on local. But this does not mean that this account is registerd on pylons chain. Now we can register an account with the key added.

We can use `pylonsd tx pylons create-account` command for this. Run `pylonsd config keyring-backend test` first. Then run:

```
pylonsd tx pylons create-account <account-name> --from pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d 
```

For the `from` flag, you should give the address of the key genereated. We used the address of `jack` key. Note your chain has to be running while you create/add the keys and create the account

Press `y` for the confirm line.

The result should be like the following.

```
{"body":{"messages":[{"@type":"/Pylonstech.pylons.pylons.MsgCreateAccount","creator":"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d","username":"theaccount"}],"memo":"","timeout_height":"0","extension_options":[],"non_critical_extension_options":[]},"auth_info":{"signer_infos":[],"fee":{"amount":[],"gas_limit":"200000","payer":"","granter":""}},"signatures":[]}


confirm transaction before signing and broadcasting [y/N]: y
code: 0
codespace: ""
data: 0A2C0A2A2F50796C6F6E73746563682E70796C6F6E732E70796C6F6E732E4D73674372656174654163636F756E74
gas_used: "42140"
gas_wanted: "200000"
height: "118"
info: ""
logs:
- events:
  - attributes:
    - key: address
      value: '"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d"'
    - key: username
      value: '"theaccount"'
    type: Pylonstech.pylons.pylons.EventCreateAccount
  - attributes:
    - key: action
      value: CreateAccount
    type: message
  log: ""
  msg_index: 0
raw_log: '[{"events":[{"type":"Pylonstech.pylons.pylons.EventCreateAccount","attributes":[{"key":"address","value":"\"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d\""},{"key":"username","value":"\"theaccount\""}]},{"type":"message","attributes":[{"key":"action","value":"CreateAccount"}]}]}]'
timestamp: ""
tx: null
txhash: F8987EDFDFDE5921D45F5BC1987634CAD49666F436C12C58A11A197718F26894

```


### Create cookbook

A cookbook ie an application container for recipes for example a game. And to build recipes and items, you need to have cookbooks.

A Sample cookbook json is like the following.

```
{
  "creator": "pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d",
  "ID": "loud123456",
  "name": "Legend of the Undead Dragon",
  "nodeVersion": "v0.3.1",
  "description": "Cookbook for running pylons recreation of LOUD",
  "developer": "Pylons Inc",
  "version": "v0.3.1",
  "supportEmail": "lyric@gmail.com",
  "costPerBlock": {"denom":  "upylon", "amount":  "1000000"},
  "enabled": true
}
```
To create a cookbook you run the following command:

 pylonsd tx pylons create-cookbook [id] [name] [description] [developer] [version] [support-email] [cost-per-block] [enabled] [flags]
```
 pylonsd tx pylons create-cookbook "loud123456" "Legend of the Undead Dragon" "Cookbook for running pylons recreation of LOUD" "Pylons Inc" v0.3.1 lyri@gmail.com "{\"denom\":  \"upylon\", \"amount\":  \"1000000\"}" true --from Jack
```
On clicking enter you get the below and need to enter 'y' to confirm transaction before signing and broadcasting.
```
{"body":{"messages":[{"@type":"/Pylonstech.pylons.pylons.MsgCreateCookbook","creator":"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d","ID":"loud123456","name":"Legend of the Undead Dragon","description":"Cookbook for running pylons recreation of LOUD","developer":"Pylons Inc","version":"v0.3.1","supportEmail":"lyri@gmail.com","costPerBlock":{"denom":"upylon","amount":"1000000"},"enabled":true}],"memo":"","timeout_height":"0","extension_options":[],"non_critical_extension_options":[]},"auth_info":{"signer_infos":[],"fee":{"amount":[],"gas_limit":"200000","payer":"","granter":""}},"signatures":[]}

```
confirm transaction before signing and broadcasting [y/N]: y

```
code: 0
codespace: ""
data: 0A2D0A2B2F50796C6F6E73746563682E70796C6F6E732E70796C6F6E732E4D7367437265617465436F6F6B626F6F6B
gas_used: "38901"
gas_wanted: "200000"
height: "11681"
info: ""
logs:
- events:
  - attributes:
    - key: creator
      value: '"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d"'
    - key: ID
      value: '"loud123456"'
    type: Pylonstech.pylons.pylons.EventCreateCookbook
  - attributes:
    - key: action
      value: CreateCookbook
    type: message
  log: ""
  msg_index: 0
raw_log: '[{"events":[{"type":"Pylonstech.pylons.pylons.EventCreateCookbook","attributes":[{"key":"creator","value":"\"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d\""},{"key":"ID","value":"\"loud123456\""}]},{"type":"message","attributes":[{"key":"action","value":"CreateCookbook"}]}]}]'
timestamp: ""
tx: null
txhash: B95D125F4E4D8448C66E4D10966717584CF45D0814D894FA0F30055107D8769B


```
Check the details of a transaction using pylonsd query tx <tx-hash>

```
pylonsd q tx B95D125F4E4D8448C66E4D10966717584CF45D0814D894FA0F30055107D8769B

  
code: 0
codespace: ""
data: 0A2D0A2B2F50796C6F6E73746563682E70796C6F6E732E70796C6F6E732E4D7367437265617465436F6F6B626F6F6B
gas_used: "38901"
gas_wanted: "200000"
height: "11681"
info: ""
logs:
- events:
  - attributes:
    - key: creator
      value: '"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d"'
    - key: ID
      value: '"loud123456"'
    type: Pylonstech.pylons.pylons.EventCreateCookbook
  - attributes:
    - key: action
      value: CreateCookbook
    type: message
  log: ""
  msg_index: 0
raw_log: '[{"events":[{"type":"Pylonstech.pylons.pylons.EventCreateCookbook","attributes":[{"key":"creator","value":"\"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d\""},{"key":"ID","value":"\"loud123456\""}]},{"type":"message","attributes":[{"key":"action","value":"CreateCookbook"}]}]}]'
timestamp: "2021-11-08T19:17:47Z"
tx:
  '@type': /cosmos.tx.v1beta1.Tx
  auth_info:
    fee:
      amount: []
      gas_limit: "200000"
      granter: ""
      payer: ""
    signer_infos:
    - mode_info:
        single:
          mode: SIGN_MODE_DIRECT
      public_key:
        '@type': /cosmos.crypto.secp256k1.PubKey
        key: AlFMPMg8rbOEmYGC0nYmfUJHIdoFWnUT0gs1A6k3qAri
      sequence: "1"
  body:
    extension_options: []
    memo: ""
    messages:
    - '@type': /Pylonstech.pylons.pylons.MsgCreateCookbook
      ID: loud123456
      costPerBlock:
        amount: "1000000"
        denom: upylon
```


### Create recipe

Recipe defines actions like generate items and modify items, generate coins etc.

To create a recipe you run the following command:
  ```
   pylonsd tx pylons create-recipe [cookbook-id] [id] [name] [description] [version] [coin-inputs] [item-inputs] [entries] [outputs] [block-interval] [enabled] [extra-info] [flags]
```
  
An example of this run against the testnet is:
  ```
  pylonsd tx pylons create-recipe testCookbookStripe recipeNostripe1 testRecipe "this is a test recipe" v0.0.1 
  '[{"coins": [{"denom": "upylon", "amount": "100000000000"}]}]' '[]' '{"coinOutputs": [],"itemOutputs": [{"ID": "id1","doubles": 
  [{"key": "Residual","weightRanges": [{"lower": "2.000000000000000000","upper": "2.000000000000000000","weight": 1}]}],"longs": 
  [{"key": "Quantity","weightRanges": [{"lower": 34,"upper": 34,"weight": 1}]},{"key": "Width","weightRanges": [{"lower": 960,"upper": 960,"weight": 1}]},
  {"key": "Height","weightRanges": [{"lower": 1280,"upper": 1280,"weight": 1}]}],"strings": [{"key": "App_Type","value": "Easel"},
  {"key": "Name","value": "How do you do turn this on"},{"key": "Description","value": "I am the representation of a LOUD recipe "},
  {"key": "NFT_URL","value": "https://i.imgur.com/dpNqwvl.jpg"},{"key": "Currency","value": "upylon"},{"key": "Price","value": "450"}],
  "mutableStrings": [],"transferFee": [],"tradePercentage": "0.100000000000000000","amountMinted": 1,"tradeable": true}],"itemModifyOutputs": []}' 
  '[{"entryIDs": ["id1"],"weight": 1}]' 1 true "" --from giunat --node https://rpc.pylons.smartnodes.co:443 --chain-id pylons-testnet                                        
 ```
  if you choose to run this locally using the Jack account we defined above:
  ```
  pylonsd tx pylons create-recipe testCookbookStripe recipeNostripe1 testRecipe "this is a test recipe" v0.0.1 
  '[{"coins": [{"denom": "upylon", "amount": "100000000000"}]}]' '[]' '{"coinOutputs": [],"itemOutputs": [{"ID": "id1","doubles": 
  [{"key": "Residual","weightRanges": [{"lower": "2.000000000000000000","upper": "2.000000000000000000","weight": 1}]}],"longs": 
  [{"key": "Quantity","weightRanges": [{"lower": 34,"upper": 34,"weight": 1}]},{"key": "Width","weightRanges": [{"lower": 960,"upper": 960,"weight": 1}]},
  {"key": "Height","weightRanges": [{"lower": 1280,"upper": 1280,"weight": 1}]}],"strings": [{"key": "App_Type","value": "Easel"},
  {"key": "Name","value": "How do you do turn this on"},{"key": "Description","value": "I am the representation of a LOUD recipe "},
  {"key": "NFT_URL","value": "https://i.imgur.com/dpNqwvl.jpg"},{"key": "Currency","value": "upylon"},{"key": "Price","value": "450"}],
  "mutableStrings": [],"transferFee": [],"tradePercentage": "0.100000000000000000","amountMinted": 1,"tradeable": true}],"itemModifyOutputs": []}'
  '[{"entryIDs": ["id1"],"weight": 1}]' 1 true "" --from Jack
  ```
  On running this:
  
  ```
  {"body":{"messages":[{"@type":"/Pylonstech.pylons.pylons.MsgCreateRecipe","creator":"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d","cookbookID":"loud1234567","ID":"recipeNostripe1","name":"testRecipe","description":"this is a test recipe","version":"v0.0.1","coinInputs":[{"coins":[{"denom":"upylon","amount":"100000000000"}]}],"itemInputs":[],"entries":{"coinOutputs":[],"itemOutputs":[{"ID":"id1","doubles":[{"key":"Residual","weightRanges":[{"lower":"2.000000000000000000","upper":"2.000000000000000000","weight":"1"}],"program":""}],"longs":[{"key":"Quantity","weightRanges":[{"lower":"34","upper":"34","weight":"1"}],"program":""},{"key":"Width","weightRanges":[{"lower":"960","upper":"960","weight":"1"}],"program":""},{"key":"Height","weightRanges":[{"lower":"1280","upper":"1280","weight":"1"}],"program":""}],"strings":[{"key":"App_Type","value":"Easel","program":""},{"key":"Name","value":"How do you do turn this on","program":""},{"key":"Description","value":"I am the representation of a LOUD recipe ","program":""},{"key":"NFT_URL","value":"https://i.imgur.com/dpNqwvl.jpg","program":""},{"key":"Currency","value":"upylon","program":""},{"key":"Price","value":"450","program":""}],"mutableStrings":[],"transferFee":[],"tradePercentage":"0.100000000000000000","quantity":"0","amountMinted":"1","tradeable":true}],"itemModifyOutputs":[]},"outputs":[{"entryIDs":["id1"],"weight":"1"}],"blockInterval":"1","enabled":true,"extraInfo":""}],"memo":"","timeout_height":"0","extension_options":[],"non_critical_extension_options":[]},"auth_info":{"signer_infos":[],"fee":{"amount":[],"gas_limit":"200000","payer":"","granter":""}},"signatures":[]}

confirm transaction before signing and broadcasting [y/N]: y
  
code: 0
codespace: ""
data: 0A2B0A292F50796C6F6E73746563682E70796C6F6E732E70796C6F6E732E4D7367437265617465526563697065
gas_used: "46511"
gas_wanted: "200000"
height: "22682"
info: ""
logs:
- events:
  - attributes:
    - key: ID
      value: '"recipeNostripe1"'
    - key: creator
      value: '"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d"'
    - key: CookbookID
      value: '"loud1234567"'
    type: Pylonstech.pylons.pylons.EventCreateRecipe
  - attributes:
    - key: action
      value: CreateRecipe
    type: message
  log: ""
  msg_index: 0
raw_log: '[{"events":[{"type":"Pylonstech.pylons.pylons.EventCreateRecipe","attributes":[{"key":"ID","value":"\"recipeNostripe1\""},{"key":"creator","value":"\"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d\""},{"key":"CookbookID","value":"\"loud1234567\""}]},{"type":"message","attributes":[{"key":"action","value":"CreateRecipe"}]}]}]'
timestamp: ""
tx: null
txhash: E15F5387AD8AD1A97B57AA3AD957EE105E790A61340E1E00E5F608E7F56EF32F
  ```
  
  Another example of a recipe is as follows:
  
```
{
  "cookbookID": "cookbookLOUD",
  "ID": "LOUDFightWolfWithSword123125",
  "name": "LOUD-Fight-Wolf-With-Sword-Recipe",
  "description": "creates a fight instance with a wolf requiring a character and a sword",
  "version": "v0.0.1",
  "coinInputs": [],
  "itemInputs": [
   {
    "ID": "character",
    "doubles": [
     {
      "key": "XP",
      "minValue": "1.000000000000000000",
      "maxValue": "10000000.000000000000000000"
     }
    ],
    "longs": [
     {
      "key": "level",
      "minValue": 1,
      "maxValue": 10000000
     }
    ],
    "strings": [
     {
      "key": "entityType",
      "value": "character"
     }
    ],
    "conditions": {
     "doubles": [],
     "longs": [],
     "strings": []
    }
   },
   {
    "ID": "sword",
    "doubles": [
     {
      "key": "attack",
      "minValue": "1.000000000000000000",
      "maxValue": "10000000.000000000000000000"
     }
    ],
    "longs": [
     {
      "key": "level",
      "minValue": 1,
      "maxValue": 10000000
     }
    ],
    "strings": [],
    "conditions": {
     "doubles": [],
     "longs": [],
     "strings": []
    }
   }
  ],
  "entries": {
   "coinOutputs": [
    {
     "ID": "coin_reward",
     "coin": {
      "denom": "cookbookLOUD/loudCoin",
      "amount": "10"
     }
    }
   ],
   "itemOutputs": [
    {
     "ID": "wolf_tail",
     "doubles": [
      {
       "key": "attack",
       "weightRanges": [],
       "program": "0.0"
      }
     ],
     "longs": [
      {
       "key": "level",
       "weightRanges": [],
       "program": "1"
      },
      {
       "key": "value",
       "weightRanges": [],
       "program": "140"
      }
     ],
     "strings": [
      {
       "key": "name",
       "value": "Wolf Tail"
      }
     ],
     "mutableStrings": [],
     "transferFee": [],
     "tradePercentage": "0.100000000000000000",
     "tradeable": true
    },
    {
     "ID": "wolf_fur",
     "doubles": [
      {
       "key": "attack",
       "weightRanges": [],
       "program": "0.0"
      }
     ],
     "longs": [
      {
       "key": "level",
       "weightRanges": [],
       "program": "1"
      },
      {
       "key": "value",
       "weightRanges": [],
       "program": "140"
      }
     ],
     "strings": [
      {
       "key": "Name",
       "value": "Wolf Fur"
      }
     ],
     "mutableStrings": [],
     "transferFee": [],
     "tradePercentage": "0.100000000000000000",
     "tradeable": true
    }
   ],
   "itemModifyOutputs": [
    {
     "ID": "modified_character",
     "itemInputRef": "character",
     "doubles": [
      {
       "key": "XP",
       "weightRanges": [],
       "program": "XP + double(15 * 3)"
      }
     ],
     "longs": [
      {
       "key": "level",
       "weightRanges": [],
       "program": "level + int(XP / double(level * level * level + 5))"
      }
     ],
     "strings": [],
     "mutableStrings": [],
     "transferFee": [],
     "tradePercentage": "0.100000000000000000",
     "tradeable": true
    },
    {
     "ID": "sword",
     "itemInputRef": "sword",
     "doubles": [],
     "longs": [],
     "strings": [],
     "mutableStrings": [],
     "transferFee": [],
     "tradePercentage": "0.100000000000000000",
     "tradeable": true
    }
   ]
  },
  "outputs": [
   {
    "weight": 3
   },
   {
    "entryIDs": [
     "coin_reward",
     "modified_character"
    ],
    "weight": 3
   },
   {
    "entryIDs": [
     "coin_reward",
     "modified_character",
     "sword"
    ],
    "weight": 24
   },
   {
    "entryIDs": [
     "coin_reward",
     "modified_character",
     "sword",
     "wolf_tail"
    ],
    "weight": 40
   },
   {
    "entryIDs": [
     "coin_reward",
     "modified_character",
     "sword",
     "wolf_fur"
    ],
    "weight": 30
   }
  ],
  "enabled": true,
  "extraInfo": "extraInfo"
 }
```


### Execute the recipe

The recipe is created. We need to execute the created recipe now.

We do this by: 
  
  pylonsd tx pylons execute-recipe [cookbook-id] [recipe-id] [coin-inputs-index] [item-ids] [payment-info] [flags]

```
pylonsd tx pylons execute-recipe loud1234567 recipeNostripe1 0 '[]' '[{"purchaseID": "pi_3Ju3j843klKuxW9f0JrajT3q","processorName":"Pylons_Inc", "payerAddr": "pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d","amount": "1003009027","productID": "recipe/loud1234567/recipeNostripe1","signature": "AlFMPMg8rbOEmYGC0nYmfUJHIdoFWnUT0gs1A6k3qAri"}]' --from Jack
```

On hitting enter, it gives

```
{"body":{"messages":[{"@type":"/Pylonstech.pylons.pylons.MsgExecuteRecipe","creator":"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d","cookbookID":"loud1234567","recipeID":"recipeNostripe1","coinInputsIndex":"0","itemIDs":[],"paymentInfos":[{"purchaseID":"pi_3Ju3j843klKuxW9f0JrajT3q","processorName":"Pylons_Inc","payerAddr":"pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d","amount":"1003009027","productID":"recipe/loud1234567/recipeNostripe1","signature":"AlFMPMg8rbOEmYGC0nYmfUJHIdoFWnUT0gs1A6k3qAri"}]}],"memo":"","timeout_height":"0","extension_options":[],"non_critical_extension_options":[]},"auth_info":{"signer_infos":[],"fee":{"amount":[],"gas_limit":"200000","payer":"","granter":""}},"signatures":[]}


confirm transaction before signing and broadcasting [y/N]: y
  
code: 18
codespace: sdk
data: ""
gas_used: "30333"
gas_wanted: "200000"
height: "42238"
info: ""
logs: []
raw_log:
timestamp: ""
tx: null
txhash: EBC51E8343949E13AE2456B55771C3E9545C045F15E5686B963AF411F5B8EFE9
```
To get the result of executed transaction, you can use `pylonsd query tx <txHash>` command.
Set the `txHash` arg as the txHash field you get from the broadcast command.

```
pylonsd query tx EBC51E8343949E13AE2456B55771C3E9545C045F15E5686B963AF411F5B8EFE9
```

An example of the log which shows the reason of a failed transaction is as belows:

```
code: 18
codespace: sdk
data: ""
gas_used: "30333"
gas_wanted: "200000"
height: "42238"
info: ""
logs: []
raw_log: 'failed to execute message; message index: 0: error validating purchase pi_3Ju3j843klKuxW9f0JrajT3q
  - signature for Pylons_Inc is invalid: tx intended signer does not match the given
  signer: invalid request: invalid request'
timestamp: "2021-11-10T14:29:29Z"
tx:
  '@type': /cosmos.tx.v1beta1.Tx
  auth_info:
    fee:
      amount: []
      gas_limit: "200000"
      granter: ""
      payer: ""
    signer_infos:
    - mode_info:
        single:
          mode: SIGN_MODE_DIRECT
      public_key:
        '@type': /cosmos.crypto.secp256k1.PubKey
        key: AlFMPMg8rbOEmYGC0nYmfUJHIdoFWnUT0gs1A6k3qAri
      sequence: "5"
  body:
    extension_options: []
    memo: ""
    messages:
    - '@type': /Pylonstech.pylons.pylons.MsgExecuteRecipe
      coinInputsIndex: "0"
      cookbookID: loud1234567
      creator: pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d
      itemIDs: []
      paymentInfos:
      - amount: "1003009027"
        payerAddr: pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d
        processorName: Pylons_Inc
        productID: recipe/loud1234567/recipeNostripe1
        purchaseID: pi_3Ju3j843klKuxW9f0JrajT3q
        signature: AlFMPMg8rbOEmYGC0nYmfUJHIdoFWnUT0gs1A6k3qAri
      recipeID: recipeNostripe1
    non_critical_extension_options: []
    timeout_height: "0"
  signatures:
  - NVYl8pwUMzV/xzkmwl6Ru3FPme+lnLFwyhKO6bHZouQHmqKmEupgkDdsilcmnVmnRF5xiXav+K1QHILnigu5CA==
txhash: EBC51E8343949E13AE2456B55771C3E9545C045F15E5686B963AF411F5B8EFE9
  
```


### Create Trade

In this section we will attempt trading between accounts.  

   pylonsd tx pylons create-trade [coinInputs] [itemInputs] [coinOutputs] [itemOutputs] [extraInfo] [flags] --from [account]
```
 pylonsd tx pylons create-trade '[{"coins": [{"denom": "upylon", "amount": "100000000000"}]}]' '[]' '{"coinOutputs": []}' 
  '{"itemOutputs": [{"ID": "id1","doubles": [{"key": "Residual","weightRanges": [{"lower": "2.000000000000000000","upper": 
  "2.000000000000000000","weight": 1}]}],"longs": [{"key": "Quantity","weightRanges": [{"lower": 34,"upper": 34,"weight": 1}]},
  {"key": "Width","weightRanges": [{"lower": 960,"upper": 960,"weight": 1}]},{"key": "Height","weightRanges": [{"lower": 1280,"upper": 1280,"weight": 1}]}],
  "strings": [{"key": "App_Type","value": "Easel"},{"key": "Name","value": "How do you do turn this on"},{"key": "Description","value": 
  "I am the representation of a LOUD recipe "},{"key": "NFT_URL","value": "https://i.imgur.com/dpNqwvl.jpg"},
  {"key": "Currency","value": "upylon"},{"key": "Price","value": "450"}],"mutableStrings": [],"transferFee": [],"tradePercentage": "0.100000000000000000",
  "amountMinted": 1,"tradeable": true}],"itemModifyOutputs": []}' "" --from Jack
```

### Fulfill Trade  

  Now we've successfully created the trade. It's time to fulfill this trade.
  ```
  pylonsd tx pylons fulfill-trade [id] [coin-inputs-index] [items] [payment-info] [flags]
  ```
  An example of use is:
  
  ```
  pylonsd tx pylons fulfill-trade t1234567 0 '[]' '[{"purchaseID": "pi_3Ju3j843klKuxW9f0JrajT3q","processorName":"Pylons_Inc","payerAddr": "pylo16v53vnxv2vlqkpmpe490dsz6prwrtwp40jgn8d","amount": "1003009027","productID": "recipe/loud1234567/recipeNostripe1","signature": "AlFMPMg8rbOEmYGC0nYmfUJHIdoFWnUT0gs1A6k3qAri"}]' --from Jack
  ```
Now you have successfully executed the recipe, trades and you probably understood pylons about 30%.
And you are ready to go into the deep level of pylons ecosystem.

  Transaction-wise these are the transactions in Pylons:
  
  ```
Stargate Pylons App

Usage:
  pylonsd tx pylons [command]

pylons transactions subcommands

Usage:
  pylonsd tx pylons [flags]
  pylonsd tx pylons [command]

Available Commands:
  burn-debt-token          burn debt token using a redeem confirmation receipt
  cancel-trade             cancel a trade by id
  complete-execution-early pay to finalize a pending execution
  create-account           initialize an account from an address
  create-cookbook          Create a new cookbook
  create-recipe            Create a new recipe
  create-trade             Create a new Trade
  execute-recipe           Execute a recipe
  fulfill-trade            fulfill an existing trade
  google-iap-get-pylons    Get coins using Google IAP
  send-items               send items to receiver
  set-item-string          Set a mutable string field within an item
  transfer-cookbook        transfer ownership of a Cookbook to Recipient
  update-account           Broadcast message update-account
  update-cookbook          Update a cookbook
  update-recipe            Update a recipe

Flags:
  -h, --help   help for pylons

Global Flags:
      --chain-id string     The network chain ID (default "pylons")
      --home string         directory for config and data (default "/Users/conwuliri/.pylons")
      --log_format string   The logging format (json|plain) (default "plain")
      --log_level string    The logging level (trace|debug|info|warn|error|fatal|panic) (default "info")
      --trace               print out full stack trace on errors
```

  
## Conclusion

Please suggest feedback on this document from game developer's perspective.
