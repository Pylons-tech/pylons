# Introduction

FAQ is frequently asked questions for pylons ecosystem.

# FAQs

## When fixture test can fail even though recipes and cookbooks are all correct?
- insufficient account balance to create cookbook
- no account registered on node
- no account registered on local
- daemon not opened
- rest server not opened
- deployment of same recipe id and cookbook id

## How much fee do you pay for pylons?
- As a game owner, you need to pay for cookbook creation
- As a game player, you pay for paid game recipes and 20% goes to Pylons LLC

## What's the benefit of using Pylons over Ethereum and other game platforms?
- Pylons is a game specific blockchain
- The broader player community
- Easier game items trading using the provided infra
- Trading items between games
- Don't need to know solidity
- No gas is required for every transaction
- Faster transactions

## What kind of games could be built on Pylons?
- Turn based games
- Board games

## What's the limitation of data processing amount per block?

- Need to take time to figure this out.

## FAQ in fixture test writing

- You should create account using get-pylons message but this is not runnable by using cli.
You should use POST ${REST_ENDPOINT}/txs to create account.
For simplification this stuff is done by loud game if you run `make ARGS="account_key -locald" run`

- All the keys are managed via `--key-ring=test` for tests and you should use this for most of cli use.
- You should reinstall pylonsd and pylonscli correctly before running fixture test.
- You should reinit the chain before running fixture test.
- You should be careful of the result success messages when you write the fixture test as recipe return different messages according to result of execution. If copy paste from other recipe, there can be an issue. And it's the best practice to learn what kind of messages can be returned from recipes.
- And same for trades.