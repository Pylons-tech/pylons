<!--
We could potentially replace this "# Pylons" header with a custom image (see https://github.com/tendermint/starport)
-->
# Pylons

<!-- TODO rewrite this description --->

Built on [Cosmos](http://www.cosmos.network/), Pylons is a fast and interoperable system for brands and creators to build engaging products with meaningful NFT experiences.

This repository provides the `pylonsd` daemon, the program for running a node on the [Pylons](https://pylons.tech) blockchain.
This program connects to the other nodes in the network to form a consensus, and responds to API and CLI commands from clients, including the [Pylons SDK](https://github.com/Pylons-tech/pylons_sdk).

## Quick Start
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


## Leverage docker compose to set up a test environment
```shell
METEOR_SETTINGS=$(cat settings.json) docker-compose -f docker-compose-starport.yml up -d
```

## Documentation

To learn how to use run a Pylons node, check out the [documentation pages](./docs/README.md).  To learn more about developing NFTs on Pylons, see the [Pylons SDK](https://github.com/Pylons-tech/pylons_sdk) project. 

## Talk to us!

Pylons is maintained by [Tendermint](https://tendermint.com/) and [Pylons LLC](https://pylons.tech).  Follow us to see the latest updates or get involved.

* [Discord](https://discord.gg/dZgUGy32j7)
* [Twitter](https://twitter.com/pylonstech)
* [Jobs](https://tendermint.com/careers/)

## Contributing 

We welcome contributions from everyone.  For more information about contributing, please review our [guidelines](CONTRIBUTING.md). Thank you to our Pylons contributors!
