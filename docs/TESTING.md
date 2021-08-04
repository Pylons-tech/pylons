# Testing

## Quick Start

Follow our [quick start](../README.md) guide to build and initialize the chain.

## Running tests
- Unit test command
```sh
make unit_tests
```
- Specific unit test (regular expression filter)
```sh
make unit_tests ARGS="-run TestKeeperSetExecution.*/empty_sender_tes"
```

- Integration test with local daemon command
```sh
make int_tests
```
- Specific integration test (regular expression filter)
```sh
make int_tests ARGS="-run TestFulfillTradeViaCLI"
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

### If you want to get the latest updates of pylons_sdk, use the following commands
Clean the cache
```sh
go clean -modcache
```
Get the latest pylons_sdk from GitHub
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
  pylons_llc: cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337 # this should be replaced
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

### Get help using `pylons tx`
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

### Generate a transaction JSON output
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