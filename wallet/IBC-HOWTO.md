# IBC Transfer Howto

## Setup gaiad client to point to cosmoshub

``bash
    $ gaiad config node https://rpc.testnet.cosmos.network:443
``
2 Create the keys
``bash
$ gaiad keys add charlie
``

Output :

    name: charlie
    type: local
    address: cosmos1chamgpjkyr9hc4k3t8xgevu3k83arkddv72pd0
    pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"A2XHfsQ5Hthni6/EgZ3rakaGXsAtEcUe7VORC5kaHxSj"}'
    mnemonic: ""

## Fund Charlie's account

```bash
$ curl -X POST -d '{"address": "cosmos1chamgpjkyr9hc4k3t8xgevu3k83arkddv72pd0"}' https://faucet.testnet.cosmos.network
```

output

    {"transfers":[{"coin":"100000000uphoton","status":"ok"}]}


## Setup pylonsd client to point to pylons testnet 

```bash
$ pylonsd config node https://testnet.pylons.tech:443
```
## Create the keys

```bash
$ pylonsd keys add snoopy
```

output 

    name: snoopy
    type: local
    address: cosmos1wy2l7j293agw25q9qg6jze7krjyrfkzqxrkgfe
    pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"A4/ZVwTc9bQWEv+bx2qIUJgSpc8BTuaoG4X+NFbY/tYQ"}'
    mnemonic: ""


## Verify that snoopy has not funds

```bash
$ pylonsd query bank balances cosmos1wy2l7j293agw25q9qg6jze7krjyrfkzqxrkgfe
```

output 

    balances: []
    pagination:
    next_key: null
    total: "0"


## Transfer funds from cosmos's Charlie account to Snoopy's in the pylons chain

```bash
$ gaiad tx ibc-transfer transfer transfer channel-54 cosmos1wy2l7j293agw25q9qg6jze7krjyrfkzqxrkgfe "150000uphoton" --from charlie --chain-id cosmoshub-testnet
```

output:

    {"body":{"messages":[{"@type":"/ibc.applications.transfer.v1.MsgTransfer","source_port":"transfer","source_channel":"channel-54","token":{"denom":"uphoton","amount":"150000"},"sender":"cosmos1chamgpjkyr9hc4k3t8xgevu3k83arkddv72pd0","receiver":"cosmos1wy2l7j293agw25q9qg6jze7krjyrfkzqxrkgfe","timeout_height":{"revision_number":"0","revision_height":"123202"},"timeout_timestamp":"1631909855344881406"}],"memo":"","timeout_height":"0","extension_options":[],"non_critical_extension_options":[]},"auth_info":{"signer_infos":[],"fee":{"amount":[],"gas_limit":"200000","payer":"","granter":""}},"signatures":[]}
    
    confirm transaction before signing and broadcasting [y/N]: y
    code: 0
    codespace: ""
    data: ""
    gas_used: "0"
    gas_wanted: "0"
    height: "0"
    info: ""
    logs: []
    raw_log: '[]'
    timestamp: ""
    tx: null
    txhash: BAF7F7CB71250F79858B662B2AE58404FD6D7940E019E35CBCB993DF883B71D2
    
    FEB67057700EF6BBF7BDD9CBF834463D32903EF7CC93E2A784D7D4C9C3493A68


## Check snoopy's balance balances on pylons chain

You should have something like :

```bash
pylonsd query bank balances cosmos15wrfldfs535hcqxk33208frecvmc60wuxfh38p
```

    balances:
    -   amount: "150000"
        denom: ibc/949E954E05CE9E63E072ABD13A7DAAAB338A1E57FFBC148C50D74451AB5067D1
    pagination:
    next_key: null
    total: "0"

