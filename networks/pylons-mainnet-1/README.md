# Pylons - pylons-mainnet-1 Mainnet

**Genesis File**

Genesis will be generated from the snapshot taken at block 3376450

```bash
   curl -s  https://raw.githubusercontent.com/Pylons-tech/pylons/main/networks/pylons-mainnet-1/genesis.json > ~/.pylons/config/genesis.json
```

**Genesis sha256**

Not yet available

**pylonsd version**

```bash
$ pylonsd version --long
name: Pylons
server_name: pylonsd
version: 1.1.2
commit: f9431be876e41853459d92ef05183732dfef4b16
```

**Seed nodes**

N/A

**Persistent Peers**

[Full seed nodes list](/networks/pylons-mainnet-1/persistent_peers.txt):

```
53dbaa70a1f7769f74e46ada1597f854fd616c2d@167.235.57.142:26657,7dfad917bf0cd651d75873802358e1d1d85a577d@94.130.111.155:26257,c09c7a1a50b4744011a006469c68bc2e763ef17a@88.99.3.158:10157,
```


## Setup

* You should already have a fully built node, but for completeness *

**Prerequisites:** Make sure to have [Golang >=1.18](https://golang.org/).

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
git checkout v1.1.1
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
version: 1.1.1
commit: 2bc3b684587d4acc9e2384cbbea2bc54eb699dc9
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
   pylonsd init <moniker-name> --chain-id=pylons-mainnet-1
   ```

2. Create a local key pair:

   ```sh
   > pylonsd keys add <key-name>
   ```

3. Add your account to your local genesis file with a given amount and the key you just created. Use only `2000000ubedrock`, other amounts will be ignored.

   ```bash
   pylonsd add-genesis-account $(pylonsd keys show <key-name> -a) 200000000ubedrock
   ```

4. Create the gentx, use only `200000000ubedrock`:

   ```bash
   pylonsd gentx <key-name> 200000000ubedrock --chain-id=pylons-mainnet-1
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

- Copy the generated gentx json file to `<repo_path>/pylons-mainnet-1/gentx/`

  ```sh
  > cd pylons/networks
  > cp ~/.pylons/config/gentx/gentx*.json ./pylons-mainnet-1/gentx/
  ```

- Commit and push to your repo
- Create a PR onto https://github.com/Pylons-tech/pylons
- Only PRs from individuals / groups with a history successfully running nodes will be accepted. This is to ensure the network successfully starts on time.

### Take a snapshot at the time of halt

We want to make sure there are several copies

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

