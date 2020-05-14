# pylons

Pylons daemon is the project responsible for providing rest api and amino endpoints necessary for interacting with pylons eco system


## How to

- Install

```
go clean -i all
go install ./cmd/pylonsd
go install ./cmd/pylonscli

```

- create a genesis block and some users

```

# Initialize configuration files and genesis file, the name here is "masternode", you can call it anything
pylonsd init masternode --chain-id pylonschain

# Copy the `Address` output here and save it for later use 
# [optional] add "--ledger" at the end to use a Ledger Nano S 
pylonscli keys add jack

# Copy the `Address` output here and save it for later use
pylonscli keys add alice

# Add both accounts, with coins to the genesis file
pylonsd add-genesis-account $(pylonscli keys show jack -a) 100pylon,1000jackcoin
pylonsd add-genesis-account $(pylonscli keys show alice -a) 100pylon,1000alicecoin

# Configure your CLI to eliminate need for chain-id flag
pylonscli config chain-id pylonschain
pylonscli config output json
pylonscli config indent true
pylonscli config trust-node true
```

- To create initial accounts which is going to used for local testing of integration test, Run

```
  sh init-accounts.sh
```

`michael`, `iain`, `afti`, `girish`, `eugen` account will be created after success run. Here, account passwords are `11111111`.
And each account will have 10000000pylons and 10000000 owncoin.

- start the `pylonsd` node

```

pylonsd start

```

- play with the api

```
pylonscli tx pylons get-pylons --from alice
```

- start the `rest-server` in dev mode
```
pylonscli rest-server --chain-id pylonschain --trust-node
```

## Running tests
- Unit test command

```
make unit_tests
```
- Integration test with local daemon command
```
make int_tests
```
- Fixture test with local daemon command
```
make fixture_tests
```

### Before running integration and fixture test initialize blockchain status and start daemon
Resets the blockchain database  
```
make reset_chain
```
Start daemon  
```
pylonsd start
```

## Deploying for production

- run the rest-server using `--cors` mode and use the `--laddr` as `0.0.0.0`
```
pylonscli rest-server --chain-id pylonschain --trust-node --cors *
```

## CLI based tx creation, sign and broadcast

### To get help from pylons tx, use below command
```
pylonscli tx pylons --help
```
Result is as follows
```
Pylons transactions subcommands

Usage:
  plncli tx pylons [command]

Available Commands:
  get-pylons      ask for pylons. 500 pylons per request
  send-pylons     send pylons of specific amount to the name provided
  create-cookbook create cookbook by providing the args
  update-cookbook update cookbook by providing the args
```

### To generate a transaction json, use below command
```
./pylonscli tx pylons get-pylons --from cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337 --generate-only > t.json
```
Here, `cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337` is account address, can be fetched by using `pylonscli keys show jack -a` command.
It is generating t.json like below.
```
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
```
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
```
 pylonscli tx sign create_cookbook.json --from cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2 --chain-id pylonschain > signedCreateCookbookTx.json
```
Offline sign process to sign more than 1 transactions with 1 account within 1 block on test with daemon.
```
pylonscli tx sign sample_transaction.json --account-number 2 --sequence 10 --offline --from cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2
```
Here `account-number`, `sequence` and `offline` param was added. When we are using multi-node mode, we will need to find a way to broadcast multiple transactions within one account without using offline feature.

It means signing create_cookbook tx with cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2 (`pylonscli keys show jack -a`).

This is result of successfully signed transaction.

```
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
```
pylonscli tx broadcast signedCreateCookbookTx.json 
```

Successful result
```
{
  "height": "0",
  "txhash": "8A847C81B396B07578FAEB25AA3E01FA11F03F300ECDDC8E4918A1D6F883640A"
}
```

### 3 node local cloudbuild setup guide on OSX

```
brew cask install google-cloud-sdk
gcloud components install docker-credential-gcr
gcloud auth configure-docker
gcloud components install cloud-build-local
nano ~/.bash_profile
export PATH=/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:$PATH

gcloud auth login
gcloud projects create pylons-3nbuild
gcloud config set project pylons-3nbuild
cloud-build-local --config=cloudbuild_3ntest.yaml --dryrun=false .
```