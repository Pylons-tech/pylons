# How to query transactions

TODO: pylonsd query txs command is removed or updated for cosmos sdk upgrade. We need to find correct querying functions and update the document

These are useful commands to query transactions by tags.

```sh
# new SDK
pylonsd query txs --events="message.sender=cosmos1agrkc5u7pwc2cwclmkguhc68x6d6ptf9w3ntex"
pylonsd query txs --events="transfer.recipient=cosmos1agrkc5u7pwc2cwclmkguhc68x6d6ptf9w3ntex"

# old SDK
pylonsd query txs --tags tx.hash:A82E3CBD9BA956C9B0284955CDCA9A85E13213B0EAA03E58011EFB08B432C28D
pylonsd query txs --tags tx.height:3344 --page 1 --limit 100
pylonsd query txs --tags sender:cosmos1vy25zn267xwuecnrtqqqq8prr2qw6f477xz6s4 --page 1 --limit 100
pylonsd query txs --tags action:send --page 1 --limit 100
pylonsd query txs --tags action:fiat_item
pylonsd query txs --tags action:create_cookbook
pylonsd query txs --tags action:create_recipe
pylonsd query txs --tags action:execute_recipe
pylonsd query txs --tags action:check_execution
pylonsd query txs --tags action:create_trade
pylonsd query txs --tags action:fulfill_trade
pylonsd query txs --tags action:disable_trade
```

## How to get tag of specific transaction

If you run
```sh
pylonsd query tx A82E3CBD9BA956C9B0284955CDCA9A85E13213B0EAA03E58011EFB08B432C28D
```

It returns something like this
```json
{
  ...
  "tags": [
    {
      "key": "action",
      "value": "create_cookbook"
    }
  ],
  ...
}
```
This means we can query this transaction by using
```sh
pylonsd query txs --tags action:create_cookbook
```
which is `pylonsd query txs --tags <key>:<value>` according to documentation.

According to cosmos team discord channel, they said
```
<DOMAIN>/txs?sender=cosmos1y6yvdel7zys8x60gz9067fjpcpygsn62ae9x46
```
can be working.

For giving custom tag to a transaction, I need to think and research for that. But we have what we want right now.
The initial thought was to get transactions that are related to cookbook.