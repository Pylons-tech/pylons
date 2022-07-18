# Pylons - pylons-testnet-3 Testnet

**Genesis File**

[Genesis File](/networks/pylons-testnet-3/genesis.json):


```bash
   curl -s  https://raw.githubusercontent.com/Pylons-tech/pylons/main/networks/pylons-testnet-3/genesis.json > ~/.pylons/config/genesis.json
```

**Genesis sha256**

```bash
sha256sum ~/.pylons/config/genesis.json
# fc73de29a03664b0e0fdfd05c815d65fbb7bb6690f561553ae0b8e969a0babbb
```

**pylonsd version**

```bash
$ pylonsd version --long
name: Pylons
server_name: pylonsd
version: 0.4.2
commit: 89479b96c93ff293144ae4205a91affc806b09c8
```

**Seed nodes**

N/A

**Persistent Peers**

[Full seed nodes list](/networks/pylons-testnet-3/persistent_peers.txt):

```
53dbaa70a1f7769f74e46ada1597f854fd616c2d@167.235.57.142:26657,7dfad917bf0cd651d75873802358e1d1d85a577d@94.130.111.155:26257,c09c7a1a50b4744011a006469c68bc2e763ef17a@88.99.3.158:10157,
```


## Setup

**Prerequisites:** Make sure to have [Golang >=1.17](https://golang.org/).

#### Build from source

You need to ensure your gopath configuration is correct. If the following **'make'** step does not work then you might have to add these lines to your .profile or .zshrc in the users home folder:

```sh
nano ~/.profile
```

```
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
```

Source update .profile

```sh
source .profile
```

```sh
git clone https://github.com/Pylons-tech/pylons
cd pylons
git checkout v0.4.2
make build && make install
```

This will build and install `pylonsd` binary into `$GOBIN`.

Note: When building from source, it is important to have your `$GOPATH` set correctly. When in doubt, the following should do:

```sh
mkdir ~/go
export GOPATH=~/go
```

Check that you have the right Pylons version installed:

```sh
$ pylonsd version --long
name: Pylons
server_name: pylonsd
version: 0.4.2
commit: 89479b96c93ff293144ae4205a91affc806b09c8
```

### Minimum hardware requirements

- 16GB RAM
- 500GB of disk space
- 4 cores

## Setup validator node

Below are the instructions to generate & submit your genesis transaction

### Generate genesis transaction (gentx)

1. Initialize the Pylons directories and create the local genesis file with the correct chain-id:

   ```bash
   pylonsd init <moniker-name> --chain-id=pylons-testnet-3
   ```

2. Create a local key pair:

   ```sh
   > pylonsd keys add <key-name>
   ```

3. Add your account to your local genesis file with a given amount and the key you just created. Use only `10000000000upylon`, other amounts will be ignored.

   ```bash
   pylonsd add-genesis-account $(pylonsd keys show <key-name> -a) 10000000000upylon
   ```

4. Create the gentx, use only `9000000000upylon`:

   ```bash
   pylonsd gentx <key-name> 9000000000upylon --chain-id=pylons-testnet-3
   ```

   If all goes well, you will see a message similar to the following:

   ```bash
   Genesis transaction written to "/home/user/.pylons/config/gentx/gentx-******.json"
   ```

### Submit genesis transaction

- Fork [the pylons repo](https://github.com/Pylons-tech/pylons) into your Github account

- Clone your repo using

  ```bash
  git clone https://github.com/<your-github-username>/pylons.git
  ```

- Copy the generated gentx json file to `<repo_path>/pylons-testnet-3/gentx/`

  ```sh
  > cd pylons/networks
  > cp ~/.pylons/config/gentx/gentx*.json ./pylons-testnet-3/gentx/
  ```

- Commit and push to your repo
- Create a PR onto https://github.com/Pylons-tech/pylons
- Only PRs from individuals / groups with a history successfully running nodes will be accepted. This is to ensure the network successfully starts on time.

#### Running in production

Download Genesis file when the time is right. Put it in your `/home/<user>/.pylons` folder.

create a systemd file for your Pylons service:

```sh
sudo nano /etc/systemd/system/pylonsd.service
```

Copy and paste the following and update `<YOUR_USERNAME>` and `<CHAIN_ID>`:

```sh
Description=Pylons daemon
After=network-online.target

[Service]
User=Pylons
ExecStart=/home/<YOUR_USERNAME>/go/bin/pylonsd start
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
```

Enable and start the new service:

```sh
sudo systemctl enable pylonsd
sudo systemctl start pylonsd
```

Check status:

```sh
pylonsd status
```

Check logs:

```sh
journalctl -u pylonsd -f
```

### Learn more

- [Pylons Documentation](https://github.com/Pylons-tech/pylons/tree/main/docs/)

