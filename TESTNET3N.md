# Testnet genesis configuration builder command

```
pylonsd testnet --v 3 --output-dir ./build --starting-ip-address 192.168.10.2 --keyring-backend=test
```

# Check number of peers by using http port

http://127.0.0.1:26657/net_info
http://127.0.0.1:26660/net_info
http://127.0.0.1:26662/net_info


# Sample peers info when connected

```
{
  "jsonrpc": "2.0",
  "id": -1,
  "result": {
    "listening": true,
    "listeners": [
      "Listener(@)"
    ],
    "n_peers": "2",
    "peers": [
      {
        "node_info": {
          "protocol_version": {
            "p2p": "7",
            "block": "10",
            "app": "0"
          },
          "id": "fa8d22b1b289cd0a73bd8bcf865f0e365ad83866",
          "listen_addr": "tcp://0.0.0.0:26656",
          "network": "pylonschain",
          "version": "0.33.3",
          "channels": "4020212223303800",
          "moniker": "node2",
          "other": {
            "tx_index": "on",
            "rpc_address": "tcp://0.0.0.0:26657"
          }
        },
        "is_outbound": false,
        "connection_status": {
          "Duration": "19154074470",
          "SendMonitor": {
            "Start": "2020-05-04T10:39:14.12Z",
            "Bytes": "7296",
            "Samples": "19",
            "InstRate": "141",
            "CurRate": "158",
            "AvgRate": "381",
            "PeakRate": "14230",
            "BytesRem": "0",
            "Duration": "19160000000",
            "Idle": "4300000000",
            "TimeRem": "0",
            "Progress": 0,
            "Active": true
          },
          "RecvMonitor": {
            "Start": "2020-05-04T10:39:14.12Z",
            "Bytes": "6697",
            "Samples": "19",
            "InstRate": "96",
            "CurRate": "118",
            "AvgRate": "350",
            "PeakRate": "14250",
            "BytesRem": "0",
            "Duration": "19160000000",
            "Idle": "4220000000",
            "TimeRem": "0",
            "Progress": 0,
            "Active": true
          },
          "Channels": [
            {
              "ID": 48,
              "SendQueueCapacity": "1",
              "SendQueueSize": "0",
              "Priority": "5",
              "RecentlySent": "0"
            },
            {
              "ID": 64,
              "SendQueueCapacity": "1000",
              "SendQueueSize": "0",
              "Priority": "10",
              "RecentlySent": "0"
            },
            {
              "ID": 32,
              "SendQueueCapacity": "100",
              "SendQueueSize": "0",
              "Priority": "5",
              "RecentlySent": "362"
            },
            {
              "ID": 33,
              "SendQueueCapacity": "100",
              "SendQueueSize": "0",
              "Priority": "10",
              "RecentlySent": "771"
            },
            {
              "ID": 34,
              "SendQueueCapacity": "100",
              "SendQueueSize": "0",
              "Priority": "5",
              "RecentlySent": "1521"
            },
            {
              "ID": 35,
              "SendQueueCapacity": "2",
              "SendQueueSize": "0",
              "Priority": "1",
              "RecentlySent": "20"
            },
            {
              "ID": 56,
              "SendQueueCapacity": "1",
              "SendQueueSize": "0",
              "Priority": "5",
              "RecentlySent": "0"
            },
            {
              "ID": 0,
              "SendQueueCapacity": "10",
              "SendQueueSize": "0",
              "Priority": "1",
              "RecentlySent": "0"
            }
          ]
        },
        "remote_ip": "192.168.10.4"
      },
      {
        "node_info": {
          "protocol_version": {
            "p2p": "7",
            "block": "10",
            "app": "0"
          },
          "id": "9270a477753052f8d54d60aa9dc8eca3c19ee300",
          "listen_addr": "tcp://0.0.0.0:26656",
          "network": "pylonschain",
          "version": "0.33.3",
          "channels": "4020212223303800",
          "moniker": "node0",
          "other": {
            "tx_index": "on",
            "rpc_address": "tcp://0.0.0.0:26657"
          }
        },
        "is_outbound": false,
        "connection_status": {
          "Duration": "17407155795",
          "SendMonitor": {
            "Start": "2020-05-04T10:39:15.88Z",
            "Bytes": "7299",
            "Samples": "18",
            "InstRate": "141",
            "CurRate": "152",
            "AvgRate": "419",
            "PeakRate": "14170",
            "BytesRem": "0",
            "Duration": "17400000000",
            "Idle": "4300000000",
            "TimeRem": "0",
            "Progress": 0,
            "Active": true
          },
          "RecvMonitor": {
            "Start": "2020-05-04T10:39:15.88Z",
            "Bytes": "6096",
            "Samples": "17",
            "InstRate": "48",
            "CurRate": "68",
            "AvgRate": "350",
            "PeakRate": "14190",
            "BytesRem": "0",
            "Duration": "17400000000",
            "Idle": "4220000000",
            "TimeRem": "0",
            "Progress": 0,
            "Active": true
          },
          "Channels": [
            {
              "ID": 48,
              "SendQueueCapacity": "1",
              "SendQueueSize": "0",
              "Priority": "5",
              "RecentlySent": "0"
            },
            {
              "ID": 64,
              "SendQueueCapacity": "1000",
              "SendQueueSize": "0",
              "Priority": "10",
              "RecentlySent": "1"
            },
            {
              "ID": 32,
              "SendQueueCapacity": "100",
              "SendQueueSize": "0",
              "Priority": "5",
              "RecentlySent": "350"
            },
            {
              "ID": 33,
              "SendQueueCapacity": "100",
              "SendQueueSize": "0",
              "Priority": "10",
              "RecentlySent": "512"
            },
            {
              "ID": 34,
              "SendQueueCapacity": "100",
              "SendQueueSize": "0",
              "Priority": "5",
              "RecentlySent": "1680"
            },
            {
              "ID": 35,
              "SendQueueCapacity": "2",
              "SendQueueSize": "0",
              "Priority": "1",
              "RecentlySent": "0"
            },
            {
              "ID": 56,
              "SendQueueCapacity": "1",
              "SendQueueSize": "0",
              "Priority": "5",
              "RecentlySent": "0"
            },
            {
              "ID": 0,
              "SendQueueCapacity": "10",
              "SendQueueSize": "0",
              "Priority": "1",
              "RecentlySent": "0"
            }
          ]
        },
        "remote_ip": "192.168.10.2"
      }
    ]
  }
}
```

# Multi-node randomness util commands

- Key add on local

```
pylonscli keys add node0 --recover
```

- Fresh blocks

```
pylonsd unsafe-reset-all --home ./build/node0/pylonsd
pylonsd unsafe-reset-all --home ./build/node1/pylonsd
pylonsd unsafe-reset-all --home ./build/node2/pylonsd
```

- 3 node running

```
docker-compose down
docker-compose build
docker-compose up
```

- single node running

```
pylonsd unsafe-reset-all
pylonsd add-genesis-account $(pylonscli keys show node0 -a) 10000000pylon
pylonsd start
pylonscli query account cosmos13p8890funv54hflk82ju0zv47tspglpk373453
```

- Query account

```
pylonscli query account cosmos13p8890funv54hflk82ju0zv47tspglpk373453
pylonscli query account cosmos13p8890funv54hflk82ju0zv47tspglpk373453 --node tcp://127.0.0.1:26662
```

- REPLACE tx_cook, tx_execute, tx_recipe, tx_get-pylons’s sender/requester attribute to $(pylonscli keys show -a node0) = cosmos13p8890funv54hflk82ju0zv47tspglpk373453

- Get 500000 pylons for testing

```
pylonscli tx sign tx_get-pylons.json --from node0 --chain-id pylonschain > signed_tx_get-pylons.json
pylonscli tx broadcast signed_tx_get-pylons.json
pylonscli query account cosmos13p8890funv54hflk82ju0zv47tspglpk373453
```
- Cookbook with ID

```
pylonscli tx sign tx_cook.json --from node0 --chain-id pylonschain > signed_tx_cook.json
pylonscli tx broadcast signed_tx_cook.json
pylonscli query tx $(RETURNED TXHASH)
pylonscli query pylons list_cookbook
```
- Recipe with ID

```
pylonscli tx sign tx_recipe.json --from node0 --chain-id pylonschain > signed_tx_recipe.json
pylonscli tx broadcast signed_tx_recipe.json
pylonscli query tx $(RETURNED TXHASH)
pylonscli query pylons list_recipe
```
- Recipe Execution which has rand_int

```
pylonscli tx sign tx_execute.json --from node0 --chain-id pylonschain > signed_tx_execute.json
pylonscli tx broadcast signed_tx_execute.json
pylonscli query tx $(RETURNED TXHASH)
```
- Cookbook without ID

```
pylonscli tx sign tx_cook_noid.json --from node0 --chain-id pylonschain > signed_tx_cook_noid.json
pylonscli tx broadcast signed_tx_cook_noid.json
pylonscli query tx $(RETURNED TXHASH)
pylonscli query pylons list_cookbook
```


