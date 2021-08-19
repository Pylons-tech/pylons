<!--
parent:
  order: false
-->

<!--
We could potentially replace this "# Pylons" header with a custom image (see https://github.com/tendermint/starport)
![banner](docs/pylons-logo.jpg)
-->

<div align="center">
  <h1> Pylons </h1>
</div>

<div align="center">
  <a href="https://github.com/Pylons-tech/pylons/releases/latest">
    <img alt="Version" src="https://img.shields.io/github/tag/Pylons-tech/pylons.svg" />
  </a>
  <a href="https://github.com/Pylons-tech/pylons/blob/master/LICENSE">
    <img alt="License: Apache-2.0" src="https://img.shields.io/github/license/Pylons-tech/pylons.svg" />
  </a>
  <a href="https://pkg.go.dev/github.com/Pylons-tech/pylons?tab=doc">
    <img alt="GoDoc" src="https://godoc.org/github.com/Pylons-tech/pylons?status.svg" />
  </a>
  <a href="https://goreportcard.com/report/github.com/Pylons-tech/pylons">
    <img alt="Go report card" src="https://goreportcard.com/badge/github.com/Pylons-tech/pylons" />
  </a>
  <a href="https://codecov.io/gh/Pylons-tech/pylons">
    <img alt="Code Coverage" src="https://codecov.io/gh/Pylons-tech/pylons/branch/develop/graph/badge.svg" />
  </a>
</div>

<div align="center">
  <a href="https://github.com/Pylons-tech/pylons">
    <img alt="Lines Of Code" src="https://tokei.rs/b1/github/Pylons-tech/pylons" />
  </a>
  <a href="https://discord.gg/3sbWqGsp">
    <img alt="Discord" src="https://img.shields.io/discord/425895893380628490.svg" />
  </a>
    <img alt="Build Status" src="https://github.com/Pylons-tech/pylons/workflows/Tests/badge.svg" />
    <img alt="Lint Status" src="https://github.com/Pylons-tech/pylons/workflows/Lint/badge.svg" />
</div>

<!-- TODO rewrite this description --->

Built on [Cosmos](http://www.cosmos.network/), **Pylons** is a fast and interoperable system for brands and creators to build engaging products with meaningful NFT experiences.

This repository provides the `pylonsd` daemon, the program for running a node on the [Pylons](https://pylons.tech) blockchain.
It connects to the other nodes in the network to form a consensus, and responds to API and CLI commands from clients, including the [Pylons SDK](https://github.com/Pylons-tech/pylons_sdk).

## Get started

```
starport chain serve
```

`serve` command installs dependencies, builds, initializes, and starts your blockchain in development.

### Configure

Your blockchain in development can be configured with `config.yml`. To learn more, see the [Starport docs](https://docs.starport.network).

### Launch

To launch your blockchain live on multiple nodes, use `starport network` commands. Learn more about [Starport Network](https://github.com/tendermint/spn).

### Web Frontend

Starport has scaffolded a Vue.js-based web app in the `vue` directory. Run the following commands to install dependencies and start the app:

```
cd vue
npm install
npm run serve
```

The frontend app is built using the `@starport/vue` and `@starport/vuex` packages. For details, see the [monorepo for Starport front-end development](https://github.com/tendermint/vue).

## Release

To release a new version of your blockchain, create and push a new tag with `v` prefix. A new draft release with the configured targets will be created.

```
git tag v0.1
git push origin v0.1
```

After a draft release is created, make your final changes from the release page and publish it.

### Install

To install the latest version of your blockchain node's binary, execute the following command on your machine:

```
curl https://get.starport.network/Pylons-tech/pylons@latest! | sudo bash
```

`Pylons-tech/pylons` should match the `username` and `repo_name` of the Github repository to which the source code was pushed. Learn more about [the install process](https://github.com/allinbits/starport-installer).

## Learn more

- [Starport](https://github.com/tendermint/starport)
- [Starport Docs](https://docs.starport.network)
- [Cosmos SDK documentation](https://docs.cosmos.network)
- [Cosmos SDK Tutorials](https://tutorials.cosmos.network)
- [Discord](https://discord.gg/W8trcGV)
