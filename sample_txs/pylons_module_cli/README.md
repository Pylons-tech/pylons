## How to create cookbook using custom cli command

```
pylonsd tx pylons create-cookbook ./x/pylons/client/cli/tx/sample_msgs/create_cookbook.json --from eugen
```

### Mandatory params
json file, --from

## How to fiat item using custom cli command

```
pylonsd tx pylons fiat-item ./x/pylons/client/cli/tx/sample_msgs/fiat_item.json --cookbookID cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey280460012-a00d-4932-9561-5ddc222265d0 --from eugen
```

### Mandatory params
json file, --from, --cookbookID


## Params description

### json file
json file contains params for cookbook creation.

### from
--from param is mandatory param.  
it can be account address or account name e.g. `eugen` or `cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2`.   
`msg.Sender` is automatically replaced with from address, so it's not needed to enter it in json file.

### cookbookID

--cookbookID param is mandatory param, it's used to set msg's cookbookID
