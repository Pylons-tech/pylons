#!/bin/bash
# microtick and bitcanna contributed significantly here.
# Pebbledb state sync script.
set -uxe

# Set Golang environment variables.
export GOPATH=~/go
export PATH=$PATH:~/go/bin

# Install Juno with pebbledb 
go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@136c7b6
go mod tidy
go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb' -tags pebbledb ./...

# NOTE: ABOVE YOU CAN USE ALTERNATIVE DATABASES, HERE ARE THE EXACT COMMANDS
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=rocksdb' -tags rocksdb ./...
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=badgerdb' -tags badgerdb ./...
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=boltdb' -tags boltdb ./...

# Initialize chain.
pylonsd init test --chain-id pylons-testnet-3

# Get Genesis
curl https://rpc-pylons-ia.notional.ventures/genesis | jq .result.genesis > ~/.pylons/config/genesis.json

# Get "trust_hash" and "trust_height".
INTERVAL=1000
LATEST_HEIGHT=$(curl -s "https://rpc-pylons-ia.notional.ventures/block" | jq -r .result.block.header.height)
BLOCK_HEIGHT=$(($LATEST_HEIGHT-$INTERVAL)) 
TRUST_HASH=$(curl -s "https://rpc-pylons-ia.notional.ventures/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

# Print out block and transaction hash from which to sync state.
echo "trust_height: $BLOCK_HEIGHT"
echo "trust_hash: $TRUST_HASH"

# Export state sync variables.
export PYLONSD_STATESYNC_ENABLE=true
export PYLONSD_P2P_MAX_NUM_OUTBOUND_PEERS=200
export PYLONSD_STATESYNC_RPC_SERVERS="https://rpc-pylons-ia.notional.ventures:443,https://rpc-pylons-ia.notional.ventures:443"
export PYLONSD_STATESYNC_TRUST_HEIGHT=$BLOCK_HEIGHT
export PYLONSD_STATESYNC_TRUST_HASH=$TRUST_HASH

# Fetch and set list of seeds from chain registry.
export PYLONSD_P2P_PERSISTENT_PEERS="28dc591d0f745870d5b29d6c8fd06a88ce2b86e4@65.108.194.40:36666,53dbaa70a1f7769f74e46ada1597f854fd616c2d@167.235.57.142:26656,2bebe6b738e849ad7355c05c4b645c381e76b774@65.108.203.219:26656,3c3ab66bd6e994d85d1a289705acc9632cef5cf0@116.202.236.115:20256,bca46a0c0dbb987de69042fd79f7b73c435f04ab@159.69.23.165:26656,3a6136175fb83857771a7c12b62c75063762324d@51.79.25.124:26656,c8467b5e9364b0b840363dd5eaa76ba6268ce48a@167.235.63.122:26656,19ded9aa4230ec347cee17987ecdf4c4fdf03e8e@195.201.170.55:26656,665a747edcb6c68d3fe317053bd2cbcae1ef0843@138.201.246.185:26656,d82520758f17da88161c9948da59485c49a801e9@185.218.126.186:26656,1377562dc51bf2d23ac368b0227e9d6deaf8c6bf@194.163.152.74:26656,53dbaa70a1f7769f74e46ada1597f854fd616c2d@167.235.57.142:26656,7dfad917bf0cd651d75873802358e1d1d85a577d@94.130.111.155:26257,c09c7a1a50b4744011a006469c68bc2e763ef17a@88.99.3.158:10157,2feb136158d7c61c16debb3af1d0ed98ad11e299@154.12.244.127:26656,1ce8ec9a119132e7ed38eca0e107fabf6f2a7d09@49.12.190.168:26656,7dcd1ce49b0b8c11da00c50fc7ed9e9d38aa5538@185.209.229.98:26656,665a747edcb6c68d3fe317053bd2cbcae1ef0843@138.201.246.185:26656,921dce09a924fe7f472ddcac6118bf8b522a96b0@65.21.123.69:26652,8def2acdf0057cbd424eea6ddf31a79c3a776155@116.203.198.83:26656,74d0a8f832d39c6751ba796e14c6ad575f2295ac@176.9.107.112:26656,3864d1ba59c65ef2eb13170ed7931d52a6afac2b@185.144.99.89:26656,9815313e9bcb6ee3f5b25c94c0a708f154db387b@65.108.137.37:26656,d0cbe3e39c25bb4860940781d86685d6681fde5e@194.163.155.84:26642,9c3261f7859a4f43a72cb9eef8d1fcfc70dc7e7c@95.216.204.255:26656,a51f452bb5581451696a3ec85ce46954ce5907e3@135.181.211.97:26677,2bebe6b738e849ad7355c05c4b645c381e76b774@65.108.203.219:26656,ae26b32c0e44c27e808da1df945cebdbe7a7ceea@95.217.225.214:28657,dee2f6f1ba39e63ce46e1e1916d1783fddc995ca@167.86.75.50:26656,3135ba79b0ba493580d1d6bc3476cbed0ab2a232@162.55.42.27:26656,17e426fed5745ee5dccd60e41a305ab0be1c405c@65.21.134.243:26674,43c84c303ce7ccd42a91ae818bb2e6cdd04f5867@178.170.40.125:26656,d82520758f17da88161c9948da59485c49a801e9@185.218.126.186:26656,b83e0f00aa40ce76637aeedb448d56f8590c7300@78.47.9.103:26656,19ded9aa4230ec347cee17987ecdf4c4fdf03e8e@195.201.170.55:26656,6788d456fc62adb73be7251b1934a6421a2e5aae@176.9.245.157:26656,fb8e2aacb9cbd88eb4a0d61db37f65f979de431e@185.207.250.12:26656,aa81f5b9d1155e5d5d59774ab194d10256384304@144.76.63.67:26737,61ca607bd6d5b041f6c472f30fd25df6f4c4a357@91.105.131.140:26656,f535b98ea21be965da7e0818ccebbfa6b874cd98@65.21.180.165:26656,47b1f883ba05a8ed4a65974f9d6ad9ceafe6d951@65.108.12.222:26697,28d06fd011f0d84953f11170d2b2a859e7b0fbcc@194.163.154.64:26656,1377562dc51bf2d23ac368b0227e9d6deaf8c6bf@194.163.152.74:26656,28dc591d0f745870d5b29d6c8fd06a88ce2b86e4@65.108.194.40:36667,0f5f30f42ada9b52c8d0b2c46baf10c60f01a63f@70.34.255.204:26656,d476546942cb2046ce22601b5717809f5839eaa2@209.145.59.195:26656,f3cdb6f2a11c0b1cb7a032a9ed6cf62c2cf27873@88.99.145.138:56157,8c00b9e6ab244adfbe230c08491cda180c9a2145@116.203.248.40:26656,ebecc93e7865036fbdf8d3d54a624941d6e41ba1@104.200.136.57:26656,3a25d216fb0ba67990b1ee471dd1de20f8501b17@65.108.201.154:2081,c8467b5e9364b0b840363dd5eaa76ba6268ce48a@167.235.63.122:26656,977dbce4a816dcffc1e7830797a2f8644c0ac179@23.88.36.127:26656,57e725a6603df139f5e75dda1f663ea5d78f49bd@161.97.87.8:26656,a73936409551a95302a4272014de814041d92512@195.3.220.169:26637,4791338ac561678ee51bcd3eec2a48d5fc46f443@142.132.248.138:26757,05ba5dbf4b52cae2684bb83f7f1ce1d646412aa4@49.12.210.174:36657,e50af597dfa8fa92bcca51348d96debead812e8e@147.135.144.56:26656,59d85e34669cdfce1bb5bb227d567de403595176@144.91.95.138:26656,7213382efc574a338167cfdb85c3b715f0dba03b@138.201.132.250:26157,f6021db0698ab71fe3cea204940f0c6b4ddb8686@51.79.26.26:26656,3a6136175fb83857771a7c12b62c75063762324d@51.79.25.124:26656"

pylonsd start --db_backend pebbledb
