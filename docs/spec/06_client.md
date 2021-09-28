<!--
order: 6
-->

# Client


## CLI

A user can query and interact with the `pylons` module using the CLI.

### Query

The `query` commands allow users to query `pylons` state.

```bash
pylonsd query pylons --help
```

#### get-cookbook

```bash
pylonsd query pylons get-cookbook [id] [flags]
```

#### get-execution

```bash
  pylonsd query pylons get-execution [id] [flags]
```

#### get-google-iap-order

```bash
  pylonsd query pylons get-google-iap-order [purchase-token] [flags]
```

#### get-item

```bash
  pylonsd query pylons get-item [cookbook-id] [id] [flags]
```

#### get-recipe

```bash
  pylonsd query pylons get-recipe [cookbook-id] [id] [flags]
```

#### get-trade

```bash
  pylonsd query pylons get-trade [id] [flags]
```

#### list-cookbooks

```bash
  pylonsd query pylons list-cookbooks [addr] [flags]
```

#### list-executions-by-item

```bash
  pylonsd query pylons list-executions-by-item [cookbook-id] [id] [flags]
```

#### list-executions-by-recipe

```bash
  pylonsd query pylons list-executions-by-item [cookbook-id] [id] [flags]
```

#### list-item-by-owner

```bash
  pylonsd query pylons list-item-by-owner [owner] [flags]
```

#### list-recipes-by-cookbook

```bash
  pylonsd query pylons list-recipes-by-cookbook [id] [flags]
```

### Transactions

The `tx` commands allow users to interact with the `pylons` module.

#### create-cookbook

```bash
  pylonsd tx pylons create-cookbook [id] [name] [description] [developer] [version] [support-email] [cost-per-block] [enabled] [flags]
```

#### transfer-cookbook

```bash
  pylonsd tx pylons transfer-cookbook [cookbookID] [recipient] [flags]
```

#### update-cookbook

```bash
  pylonsd tx pylons update-cookbook [id] [name] [description] [developer] [version] [support-email] [cost-per-block] [enabled] [flags]
```

#### create-recipe

```bash
  pylonsd tx pylons create-recipe [cookbook-id] [id] [name] [description] [version] [coin-inputs] [item-inputs] [entries] [outputs] [block-interval] [enabled] [extra-info] [flags]
```

#### update-recipe

```bash
  pylonsd tx pylons update-recipe [cookbook-id] [id] [name] [description] [version] [coinInputs] [itemInputs] [entries] [outputs] [blockInterval] [enabled] [extraInfo] [flags]
```

#### execute-recipe

```bash
  pylonsd tx pylons execute-recipe [cookbook-id] [recipe-id] [item-ids] [flags]
```

#### set-item-string

```bash
  pylonsd tx pylons set-item-string [cookbook-id] [id] [field] [value] [flags]
```

#### send-items

```bash
  pylonsd tx pylons send-items [receiver] [items] [flags]
```

#### create-trade

```bash
  pylonsd tx pylons create-trade [coinInputs] [itemInputs] [coinOutputs] [itemOutputs] [extraInfo] [flags]
```

#### cancel-trade

```bash
  pylonsd tx pylons cancel-trade [id] [flags]
```

#### fulfill-trade

```bash
  pylonsd tx pylons fulfill-trade [id] [items] [flags]
```

#### google-iap-get-pylons

```bash
  pylonsd tx pylons google-iap-get-pylons [productID] [purchaseToken] [recieptDataBase64] [signature] [flags]
```

## gRPC

A user can query the `pylons` module using gRPC endpoints.


## REST

A user can query the `pylons` module using REST endpoints.

