# pylons

Pylons daemon is the project responsible for providing rest api and amino endpoints necessary for interacting with pylons eco system


## How to

- Install

```

go install ./cmd/pylonsd
go install ./cmd/pylonscli

```

- create a genesis block and some users

```

# Initialize configuration files and genesis file
pylonsd init --chain-id pylonschain

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

## Deploying for production

- run the rest-server using `--cors` mode and use the `--laddr` as `0.0.0.0`
```
pylonscli rest-server --chain-id pylonschain --trust-node --cors *
```
