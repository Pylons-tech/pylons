---
title: "Getting Started"
date: 2022-04-26T13:04:30-05:00
draft: false
---

# Pylons Dev Tool

## Welcome!

The Pylons Dev Tool has been built to help developers deploy their cookbooks and recipes to the Pylons chain in a separate application. With the Dev Tool, you don’t need to run any Pylons node, and you don’t have to rewrite every Pylons cookbook/recipe structure within your future applications. If you are unsure about how Pylons works, be sure to give our white paper and Getting Started With Pylons documentation a look.

## Commands in CLI

```
completion  Generate the autocompletion script for the specified shell
help        Help about any command
parse       parse a json file into a valid Pylons Go struct
sim         simulate execution of a recipe or trade
version     A brief description of your command
```

## How to Run Dev Tool

Run this command in the same directory as your Pylons directory:

```
git clone https://github.com/Pylons-tech/dev-tool.git
```

Within the Pylons directory run:

```
starport chain serve
```

If you haven't created an account on the test-net before, open a new terminal window and go to the pylons directory. Use the pylonsd commands to create a new account on the test-net. [See here for instructions.](https://github.com/Pylons-tech/pylons/blob/main/docs/Developer-CLI-Tutorial.md)

Within the codebase of the dev-tool, open the developer folder and edit the `config.json` file. Add the account name that cookbooks/recipes will be created by and the home directory of the Pylons folder.

### How to find Home Directory

In your pylonsd client instance, run `pylonsd --home` and copy the location of the home directory.

### Create A Cookbook

```
go run main.go parse create-cookbook “[PATH TO JSON FILE]”
```

The create-cookbook command intakes a json file with cookbook and deploys it to the chain.

### Create A Recipe

```
go run main.go parse create-recipe “[PATH TO FILE]”
```

The create-recipe command intakes a json file with a recipe and deploys it to the chain

### Update A Cookbook

```
go run main.go parse update-cookbook “path/to/json/file”
```

The update-cookbook command takes a json file as a parameter with an updated cookbook and updates the cookbook with a matching cookbookId on the chain to match the cookbook in the json file. In order for the update to succeed, the version number must be updated.

### Update A Recipe

```
go run main.go parse update-cookbook “path/to/json/file”
```

The update-recipe command intakes a json file with an updated recipe and updates the recipe with a matching Id on the chain to match the recipein the json file. In order for the update to succeed, the version number must be updated.

## How to Verify Recipe On-Chain (bdjuno or pylonsd)

You can use bdjuno to search for the transaction on chain. However, if you’d like to check on your local use pylonsd that is configured to the testnet. You will need the hash from the submitted transaction, which appears in the terminal upon submit. <br>
Start the pylons chain from your local:

```
starport chain serve
```

In a new terminal window from same folder, run this with the hash that you wish to verify:

```
pylonsd query tx --type=hash [HASH OF TX]
```

If there are any flags you wish to search with, you may add them as necessary.