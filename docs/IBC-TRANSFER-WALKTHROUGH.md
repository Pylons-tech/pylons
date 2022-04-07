# IBC-TRANSFER-WALKTHROUGH

## Summary

We will:
1. Add the relayer account in config.yaml file
2. Specify the ports in config.yaml file
3. Install the relayer
4. Setup the relayer
5. Start the chains
6. Create the connection
7. Create the channel
8. Start the relayer
9. Make a Sample Transaction

## Add relayer account in config.yaml file

You need to add the relayer account in the config.yaml file in both chains. To add the relayer account, you can simply add the following lines in config.yaml.
```
- name: relayer
  address : "<relayer_address>"
  coins: ["10000000000upylon", "100000000ubedrock"]
```
`address` is template at this time, we need to update it later in the  guide.

## Specify the ports in config.yaml file

You need to specify the ports in the `config.yaml` file so that both chains do not use the same ports and to avoid errors.
The sample ports for `pylons/config.yaml`
  ```
host:
      rpc: ":36659"
      p2p: ":36658"
      prof: ":6062"
      grpc: ":9991"
      api: ":1318"
      frontend: ":8081"
      dev-ui: ":12346"
      grpc-web: ":9093"
```

The sample ports for `juno/config.yaml` are:
```
host:
  rpc: ":26659"
  p2p: ":26658"
  prof: ":5062"
  grpc: ":8991"
  api: ":1316"
  frontend: ":8081"
  dev-ui: ":13346"
  grpc-web: ":8093"
```
Make sure that the respective ports on both chains do not match.

## Installing the relayer

We will be using the @confio/ts-relayer.
Use this command to install the relayer:
`sudo npm i -g @confio/relayer@main`

It will allow you to use the following commands i.e. `ibc-setup` & `ibc-relayer`.

Here is the link for relayer installation : https://github.com/confio/ts-relayer

## Setting-up the relayer

You need to create a `registry.yaml` file. Use this command to create registry file
`ibc-setup init`

### Configure Registry.yaml

Open `registry.yaml` file in VS code using the following command.
`code ~/.ibc-setup/registry.yaml`
Write `chain:` and then add details of the chains as follows
```
chain:
    juno:
        chain_id: juno-1
        prefix: juno
        gas_price: 0.000001token
        ics20_port: 'transfer'
        rpc:
          - http://localhost:26659
      
    pylons:
        chain_id: pylons-1
        prefix: pylo
        gas_price: 0.000001ubedrock
        ics20_port: 'transfer'
        rpc:
          - http://localhost:36659
```
 ics20_port: default = ‘transfer’ else you can find the port-id in `x/type/keys.go`.
 rpc values can be found inside the `config.yaml` file in both chains.
 
 ### Configure app.yaml

 If the app.yaml file is not already generated along with the registry.yaml file. Use the following command to generate the app.yaml file.
 `ibc-setup init --src pylons --dest juno`
 Open the app.yaml file in the editor using the following command.
 `code ~/.ibc-setup/app.yaml`
 The file will look like this.
 ```
src: pylons
dest: juno
mnemonic: stick deputy ankle near motion banana shift normal social hill between major
srcConnection: connection-0
destConnection: connection-0
```
Add `srcConnection: connection-0` & `destConnection: connection-0`
The `mnemonic` will be used to generate the address of the relayer for both chains.

### Get the relayer address for the chains

Open the terminal inside the chain's directory and use the following command.
`<pylonsd> keys add relayer --recover --dry-run`
Write the `mnemonic`  and press enter.
The output will be like this.
```
abc@abc:~$ pylonsd keys add relayer --recover --dry-run
> Enter your bip39 mnemonic
stick deputy ankle near motion banana shift normal social hill between major

- name: relayer
  type: local
  address: pylo1qvcf7rug8k0uumxdvy0mrkyug75s9umdfa9px9
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"Ak1JEnioXVLln60raRz8kRjhoykTaQR9Cl6pF/77+T5A"}'
  mnemonic: ""


```
Copy the address and replace it in the `address` field in the relayer account in the `<pylons>/config.yml`
The lines below are for reference showing the updated  `pylons/config.yaml`
```
accounts:
  - name: alice
    coins: ["20000000000upylon", "200000000ubedrock"]
  - name: bob
    coins: ["10000000000upylon", "100000000ubedrock"]
  - name: relayer
    address : "pylo1qvcf7rug8k0uumxdvy0mrkyug75s9umdfa9px9"
    coins: ["10000000000upylon", "100000000ubedrock"]
```
 Repeat the same process for the `juno` chain .
 
 ## Start the chains
Serve both chains by opening the terminal in the chain's directory and by using the following commands.
 ```
starport chain init
starport chain serve --force-reset

```

## Create the connection.

After serving both chains, you will create a connection. This will take the details of the connection from the `registry.yaml` and `app.yaml` file.
Use this command to create a connection :
`starport tools ibc-setup connect -- -v`

The terminal output will be similar to this.
```
hassan@hassan-rns:~/work/src/old ones/pylons$ starport tools ibc-setup connect -- -v
verbose: Queried unbonding period {"seconds":1814400}
verbose: Create Tendermint client
verbose: Queried unbonding period {"seconds":1814400}
verbose: Create Tendermint client
info: Connection open init: 07-tendermint-0 => 07-tendermint-0
verbose: Get latest commit
verbose: Get validator set for height 462
verbose: Get header for height 462
verbose: Get validator set for height 452
verbose: Get header for height 452
verbose: Update Tendermint client 07-tendermint-0
info: Connection open try: 07-tendermint-0 => 07-tendermint-0 (connection-0)
verbose: Get latest commit
verbose: Get validator set for height 494
verbose: Get header for height 494
verbose: Get validator set for height 480
verbose: Get header for height 480
verbose: Update Tendermint client 07-tendermint-0
info: Connection open ack: connection-0 => connection-0
verbose: Get latest commit
verbose: Get validator set for height 476
verbose: Get header for height 476
verbose: Get validator set for height 463
verbose: Get header for height 463
verbose: Update Tendermint client 07-tendermint-0
info: Connection open confirm: connection-0
Created connections connection-0 (07-tendermint-0) <=> connection-0 (07-tendermint-0)
```

## Create the channel

To create the channel between the two chains, use the following command
`starport tools ibc-setup channel -- --src-connection <connection-0> --dest-connection <connection-0> --src-port <transfer> --dest-port <transfer> --version ics20-1
`

`--src-connection` & `--dest-connection` are the fields you specified in the `app.yaml` file.
default `--src-port` is `transfer`
default `--dest-port` is `transfer`

Screenshot of the output:
```
hassan@hassan-rns:~/work/src/old ones/pylons$ starport tools ibc-setup channel -- --src-connection connection-0 --dest-connection connection-0 --src-port transfer --dest-port transfer --version ics20-1
·
· 🛸 Starport v0.19.5 is available!
·
· If you're looking to upgrade check out the instructions: https://docs.starport.network/guide/install.html#upgrading-your-starport-installation
·
··

info: Create channel with sender pylons: transfer => transfer
Created channel:
  pylons-1: transfer/channel-0 (connection-0)
  juno-1: transfer/channel-0 (connection-0)
```

## Start the Relayer

Use this command to start the relayer:
`starport tools ibc-relayer start -- -v`

```
hassan@hassan-rns:~/work/src/old ones/pylons$ starport tools ibc-relayer start -- -v


info: Use last queried heights from /home/hassan/.ibc-setup/last-queried-heights.json file.
verbose: [juno-1] Get header for height 632
verbose: [pylons-1] Get header for height 614
verbose: Get pending packets on pylons
verbose: Get pending packets on juno
info: Relay 0 packets from pylons => juno
info: Relay 0 packets from juno => pylons
verbose: Get pending acks on pylons
verbose: Get pending acks on juno
info: Relay 0 acks from pylons => juno
info: Relay 0 acks from juno => pylons
info: Timeout 0 packets sent from pylons
info: Timeout 0 packets sent from juno
verbose: next heights to relay {"packetHeightA":700,"packetHeightB":725,"ackHeightA":702,"ackHeightB":727}
info: Ensuring clients are not stale
verbose: Checking if juno has recent header of pylons
verbose: Checking if pylons has recent header of juno
info: Sleeping 60 seconds...

```

The relayer setup is completed now.
 
 ## Sample Transaction
 
 To do a transaction between the two chains, use the following command:
 
 `<pylonsd> tx ibc-transfer transfer transfer channel-0 <reciever_address> 10000upylon --from <sender_address>`
 
 
