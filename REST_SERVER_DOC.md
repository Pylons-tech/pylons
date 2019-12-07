# Introduction

Using REST interface server is the easiest way to fetch results in REST interface.

## Running rest server
```
pylonscli rest-server --chain-id pylonschain --trust-node
```
## Fetching
This describes regular format of REST endpoints and samples for all endpoints.

### cookbooks

Format
```
http://${HOST}/pylons/list_cookbooks/${ownerKeyName}
```
Sample
```
http://localhost:1317/pylons/list_cookbooks/cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2
```

Sample Result
```
{
    "Cookbooks": []
}
```

### recipes

Format
```
http://${HOST}/pylons/list_recipe/${ownerKeyName}
```
Sample
```
http://localhost:1317/pylons/list_recipe/cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2
```

Sample Result
```
{
    "Recipes": []
}
```

### items

Format
```
http://${HOST}/pylons/items_by_sender/${ownerKeyName}
```
Sample
```
http://localhost:1317/pylons/items_by_sender/cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2
```

Sample Result
```
{
    "Items": []
}
```

### executions

Format
```
http://${HOST}/pylons/list_executions/${ownerKeyName}
```
Sample
```
http://localhost:1317/pylons/list_executions/cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2
```

Sample Result
```
{
    "Executions": []
}
```