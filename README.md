# pylons

Pylonsd daemon connect with all the other daemons around the world and process the transactions.   
On the other hand, it is responsible for providing rest api and cli commands for interacting with pylons ecosystem.

## Setup development environment

```sh
git clone https://github.com/Pylons-tech/pylons
brew install pre-commit
brew install golangci/tap/golangci-lint
go get -u golang.org/x/lint/golint
pre-commit install
```

## How to

- Install

```sh
go clean -i all
go install ./cmd/pylonsd
```

- create a genesis block and some users

```sh
# Initialize configuration files and genesis file, the name here is "masternode", you can call it anything
pylonsd init masternode --chain-id pylonschain

# Copy the `Address` output here and save it for later use 
# [optional] add "--ledger" at the end to use a Ledger Nano S 
pylonsd keys add jack

# Copy the `Address` output here and save it for later use
pylonsd keys add alice

# Add both accounts, with coins to the genesis file
pylonsd add-genesis-account $(pylonsd keys show jack -a) 100pylon,1000jackcoin
pylonsd add-genesis-account $(pylonsd keys show alice -a) 100pylon,1000alicecoin
```

- Multinode integration test is using init-account.sh. It does not use get-pylons but use the public genesis account for the tests accounts setup.
- For local genesis accounts setup for integration test, you can use `init_accounts.local.sh` file.

```sh
sh init_accounts.local.sh
```

`michael`, `eugen` account will be created after success run and will have loudcoin and pylons denom for tests.

- start the `pylonsd` node

```sh
pylonsd start
```

- play with the api

```sh
pylonsd tx pylons get-pylons --from node0 --keyring-backend=test --chain-id=pylonschain --home=$HOME/.pylonsd --yes
```

- enable rest server when starting node
```sh
sed -i 's/enable = false/enable = true/g' $HOME/.pylonsd/config/app.toml
pylonsd start --home=$HOME/.pylonsd
```

## Running tests
- Unit test command
```sh
make unit_tests
```
- Specific unit test (regular expression filter)
```sh
make unit_tests ARGS="-run TestKeeperSetExecutio.*/empty_sender_tes"
--- PASS: TestKeeperSetExecution (0.00s)
    --- PASS: TestKeeperSetExecution/empty_sender_test (0.00s)
PASS
ok  	github.com/Pylons-tech/pylons/x/pylons/keep	0.050s
```

- Integration test with local daemon command
```sh
make int_tests
```
- Specific integration test (regular expression filter)
```sh
make int_tests ARGS="-run TestFulfillTradeViaCLI"
--- PASS: TestFulfillTradeViaCLI (0.00s)
    --- PASS: TestFulfillTradeViaCLI/same_item_with_different_cookbook_id_fulfill_trade_test (31.76s)
    --- PASS: TestFulfillTradeViaCLI/coin->coin_fullfill_trade_test (37.59s)
    --- PASS: TestFulfillTradeViaCLI/trade_unordered_coin_input_test (43.35s)
    --- PASS: TestFulfillTradeViaCLI/item->item_fullfill_trade_test (49.27s)
    --- PASS: TestFulfillTradeViaCLI/item->coin_fullfill_trade_test (33.78s)
    --- PASS: TestFulfillTradeViaCLI/coin->item_fullfill_trade_test (39.66s)
PASS
ok  	github.com/Pylons-tech/pylons/cmd/test	71.481s
```

- Fixture test with local daemon command
```sh
make fixture_tests ARGS="--accounts=michael,eugen"
```
- Specific fixture test (scenario name filter)
If not specify this param, it tests all scenario files. If specify only do specific tests.
```sh
make fixture_tests ARGS="--scenarios=multi_msg_tx,double_empty --accounts=michael,eugen"
```

### Before running integration and fixture test initialize blockchain status and start daemon
Resets the blockchain database  
```sh
make reset_chain
```
Start daemon  
```sh
pylonsd start
```

### If you wanna get the latest updates of pylons_sdk, use the following commands
Clean the cache
```sh
go clean -modcache
```
Get the latest pylons_sdk from github
```sh
go get github.com/Pylons-tech/pylons_sdk@{version_number}
```

### Configuration

- File name: `pylons.yml`

```yaml
fees:
  recipe_fee_percentage: 10 # Pylons fee percentage
  cookbook_basic_fee: 10000 # Cookbook creation fee
  cookbook_premium_fee: 50000 # Cookbook creation fee
  pylons_trade_percentage: 10 # Pylons trade percentage
  minimum_trade_price: 10 # Minimum trade price
  update_item_string_field_fee: 10 # Item string field update fee
  min_item_transfer_fee: 1 # Basic item transfer fee
  max_item_transfer_fee: 100000
  item_transfer_cookbook_owner_profit_percent: 90 # Cookbook sender item transfer percent
validators:
  pylons_llc: cosmos105wr8t6y97rwv90xzhxd4juj4lsajtjaass6h7 # this should be replaced
google_iap:
  - package_name: com.pylons.loud
    product_id: pylons_1000
    amount: 1000
  - package_name: com.pylons.loud
    product_id: pylons_55000
    amount: 55000
google_iap_pubkey: XXXX
is_production: false
```

- `recipe_fee_percentage` refers to the percentage of pylons that needs to be  transfered to Pylons LLC validator address for every pylons denom paid recipe.  
- `cookbook_basic_fee` refers to the amount of pylons that needs to be paid to Pylons LLC validator address to create a basic tier cookbook creation.  
- `cookbook_premium_fee` refers to the amount of pylons that needs to be paid to Pylons LLC validator address to create a premium tier cookbook creation.  
- `pylons_trade_percentage` refers to the percentage of pylons that needs to be transfered from pylons incomer's side.
- `minimum_trade_price` refers to the minimum amount of pylons that needs to participate per trading.
- `update_item_string_field_fee` refers to item string field update fee per field
- `pylons_llc` refers to cosmos address for Pylons LLC validator.
- `min_item_transfer_fee` refers to the minimum pylons per item transfer
- `max_item_transfer_fee` refers to the maximum pylons per item transfer
- `item_transfer_cookbook_owner_profit_percent` refers to cookbook owner's profit percent in fee
- `google_iap` define google iap packages/products along with the amount associated with the package/product.
- `google_iap_pubkey` defines the google iap public key to verify google iap purchase signature
- `is_production` defines the flag to show if this configuration is for production

## CLI based tx creation, sign and broadcast

### To get help from pylons tx, use below command
```sh
pylonsd tx pylons --help
```
Result is as follows
```sh
Pylons transactions subcommands

Usage:
  pylonsd tx pylons [command]

Available Commands:
  get-pylons      ask for pylons. 500 pylons per request
  send-pylons     send pylons of specific amount to the name provided
  create-cookbook create cookbook by providing the args
  update-cookbook update cookbook by providing the args
```

### To generate a transaction json, use below command
```sh
./pylonsd tx pylons get-pylons --from cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337 --generate-only > t.json
```
Here, `cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337` is account address, can be fetched by using `pylonsd keys show jack -a` command.
It is generating t.json like below.
```json
{
  "type": "auth/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/GetPylons",
        "value": {
          "Amount": [
            {
              "denom": "pylon",
              "amount": "500"
            }
          ],
          "Requester": "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
        }
      }
    ],
    "fee": {
      "amount": null,
      "gas": "200000"
    },
    "signatures": null,
    "memo": ""
  }
}
```

On above, main part is `value.msg`. It contains msg type and msg value.
Totally, it means Requester `cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337`, have requested `500 pylons`.

Here's sample tx for `create cookbook`.
```json
{
  "type": "auth/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/CreateCookbook",
        "value": {
          "Description": "this has to meet character limits lol",
          "Developer": "SketchyCo",
          "Level": "0",
          "Name": "Morethan8Name",
          "Sender": "cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2",
          "SupportEmail": "example@example.com",
          "Version": "1.0.0"
        }
      }
    ],
    "fee": {
      "amount": null,
      "gas": "200000"
    },
    "signatures": null,
    "memo": ""
  }
}
```

This will enough for understanding structure of Transaction.

### Transaction sign process

Sample command.  
```sh
 pylonsd tx sign create_cookbook.json --from cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2 --chain-id pylonschain > signedCreateCookbookTx.json
```
Offline sign process to sign more than 1 transactions with 1 account within 1 block on test with daemon.
```sh
pylonsd tx sign sample_transaction.json --account-number 2 --sequence 10 --offline --from cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2
```
Compute private key from mnemonic.
```sh
pylonsd keys add aaa --keyring-backend=test
{
  "name": "aaa",
  "type": "local",
  "address": "cosmos193tx7cz09yf7xsd0tj3ts5c2v3vumjmmzdvk0g",
  "pubkey": "cosmospub1addwnpepqv2c5ew9td4tjz8t9qyukat844kmpmdq6hkqse4kfs3aag63r8hw5uxf07j",
  "mnemonic": "wait teach develop tumble glance crash habit lonely army liar exit indoor cancel wedding scan face easy anxiety final run logic raw wife flight"
}
pylonsd tx pylons compute-private "wait teach develop tumble glance crash habit lonely army liar exit indoor cancel wedding scan face easy anxiety final run logic raw wife flight"
```
Private key based sign process for mobile side check.
```sh
# online private key based sign
pylonsd tx pylons sign sample_txs/tx_sign_privkey.json --private-key be8cec408a01f5d1ad9981c4153f0f037eff6014cff774f230517822c3ed2127
# offline private key based sign
pylonsd tx pylons sign sample_txs/tx_sign_privkey.json --offline --account-number 0 --sequence 0 --private-key 276c784fe02abd8438cb9275ea22771dc7259b075d2404618ea6ec41736664c3
```
Here `account-number`, `sequence` and `offline` param was added. When we are using multi-node mode, we will need to find a way to broadcast multiple transactions within one account without using offline feature.

It means signing create_cookbook tx with cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2 (`pylonsd keys show jack -a`).

This is result of successfully signed transaction.

```json
{
  "type": "auth/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/CreateCookbook",
        "value": {
          "Name": "name",
          "Description": "this has to meet character limits lol",
          "Version": "1.0.0",
          "Developer": "SketchyCo",
          "SupportEmail": "example@example.com",
          "Level": "0",
          "Sender": "cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2"
        }
      }
    ],
    "fee": {
      "amount": null,
      "gas": "200000"
    },
    "signatures": [
      {
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "AnzIM9IcLb07Cvwq3hdMJuuRofAgxfDekkD3nJUPPw0w"
        },
        "signature": "6t3INv+sTpeXaiEANuZT5VgKjQz5cEUBAVtdSy7TntNu7aKHNaELrTRKqHZxZCsu9K6TIW9fMlqD/wyW4ncgqA=="
      }
    ],
    "memo": ""
  }
}
```

signatures field was modified.

### Broadcast signed transaction
```sh
pylonsd tx broadcast signedCreateCookbookTx.json 
```

Successful result
```json
{
  "height": "0",
  "txhash": "8A847C81B396B07578FAEB25AA3E01FA11F03F300ECDDC8E4918A1D6F883640A"
}
```

### single node docker test local

Test daemon build
```sh
docker build . --target pylonsd
docker run <id>
```
Test daemon build with integration test
```sh
docker build . --target integration_test
docker run <id>
```
Test daemon build with fixture test
```sh
docker build . --target fixture_test
docker run <id>
```
Test daemon build with both integration test and fixture test
```sh
docker build . --target all_test
docker run <id>
```

### 3 node local cloudbuild setup guide on OSX

```sh
brew cask install google-cloud-sdk
gcloud components install docker-credential-gcr
gcloud auth configure-docker
gcloud components install cloud-build-local
nano ~/.bash_profile
export PATH=/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:$PATH

gcloud auth login
gcloud projects create pylons-3nbuild
gcloud config set project pylons-3nbuild
cloud-build-local --config=cloudbuild.3ntest.yaml --dryrun=false .
```

# How to query transactions

TODO: pylonsd query txs command is removed or updated for cosmos sdk upgrade. We need to find correct querying functions and update the document

These are useful commands to query transactions by tags.

```sh
pylonsd query txs --tags tx.hash:A82E3CBD9BA956C9B0284955CDCA9A85E13213B0EAA03E58011EFB08B432C28D
pylonsd query txs --tags tx.height:3344 --page 1 --limit 100
pylonsd query txs --tags sender:cosmos1vy25zn267xwuecnrtqqqq8prr2qw6f477xz6s4 --page 1 --limit 100
pylonsd query txs --tags action:send --page 1 --limit 100
pylonsd query txs --tags action:fiat_item
pylonsd query txs --tags action:create_cookbook
pylonsd query txs --tags action:create_recipe
pylonsd query txs --tags action:execute_recipe
pylonsd query txs --tags action:check_execution
pylonsd query txs --tags action:create_trade
pylonsd query txs --tags action:fulfill_trade
pylonsd query txs --tags action:disable_trade
```

## How to get tag of specific transaction

If you run 
```sh
pylonsd query tx A82E3CBD9BA956C9B0284955CDCA9A85E13213B0EAA03E58011EFB08B432C28D
```

It returns something like this
```json
{
  ...
  "tags": [
    {
      "key": "action",
      "value": "create_cookbook"
    }
  ],
  ...
}
```
This means we can query this transaction by using
```sh
pylonsd query txs --tags action:create_cookbook
```
which is `pylonsd query txs --tags <key>:<value>` according to documentation.

According to cosmos team discord channel, they said
```
<DOMAIN>/txs?sender=cosmos1y6yvdel7zys8x60gz9067fjpcpygsn62ae9x46
```
can be working.

For giving custom tag to a transaction, I need to think and research for that. But we have what we want right now.
The initial thought was to get transactions that are related to cookbook.
