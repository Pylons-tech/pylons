# Quick Start


## Using Make

* Install

```shell
make clean
make install
```
* Initialize and start the chain locally

```shell
make init_accounts_local
```

* Restart the chain
```shell
pylonsd start
```
## Using Starport
```shell
starport chain serve
```

## Using Docker compose
```shell
METEOR_SETTINGS=$(cat settings.json) docker-compose -f docker-compose-starport.yml up -d
```

