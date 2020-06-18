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

## How does minus weights work? 
e.g. 
```
    "Outputs": [
        {
            "ResultEntries": [],
            "Weight": "-11"
        },
        {
            "ResultEntries": [],
            "Weight": "Mana - rand() * 20.0"
        }
    ]
```
Minus weights are processed as 0.
This is useful when the Weight is a kind of expression expression that has possibility of less than 0.
It removes the expression max of 0 that's common.

## FAQ in fixture test writing

- You should create account using get-pylons message but this is not runnable by using cli.
You should use POST ${REST_ENDPOINT}/txs to create account.
For simplification this stuff is done by loud game if you run `make ARGS="account_key -locald" run`

- All the keys are managed via `--keyring-backend=test` (which is an argument of pylonscli) for tests and you should use this for most of test related cli use and other actions that does not require user's system password.
- You should reinstall pylonsd and pylonscli correctly before running fixture test.
- You should reinit the chain before running fixture test. If you are using local daemon, try to run `sh init_accounts.local.sh`.
- You should be careful of the result success messages when you write the fixture test as recipe return different messages according to result of execution. If copy paste from other recipe, there can be an issue. And it's the best practice to learn what kind of messages can be returned from recipes.
- If you want to upgrade or generate an item or coin, you should create receipe first and then not forget to execute the receipe. create recipe is not something that run the recipe.
- For trades, you need to create trade and fulfill the trade, please take care of trade return messages as they are different from recipes.
- How to debug long list of `signature verification failed` issue?
```json
    TestFixturesViaCLI/scenarios/helicopter.json/0_CREATE_HELICOPTER_COOKBOOK: evtesting.go:311: level=info output={
          "height": "0",
          "txhash": "CDF0F3D94BF1964C1C776A4CC8E90DBC3B8FF3A93E9399846021B463BF2F3F96",
          "code": 4,
          "raw_log": "unauthorized: signature verification failed; verify correct account sequence and chain-id"
        }
         max_retry=48 log="pylonscli tx broadcast /var/folders/_z/rdr0tp0n00x0pt6qm9n9ktgr0000gn/T/pylons375604730/signed_tx_3.json --node tcp://localhost:26657" ==>
        {
          "height": "0",
          "txhash": "CDF0F3D94BF1964C1C776A4CC8E90DBC3B8FF3A93E9399846021B463BF2F3F96",
          "code": 4,
          "raw_log": "unauthorized: signature verification failed; verify correct account sequence and chain-id"
        }
        
         msg=rebroadcasting after 1s...
```
Try to comment on rest of test code and run one by one to get correct issue.

- What's the meaning of this issue?    
```json
level=fatal owner_address=cosmos1qzu2w5rkfs3vhenguupahhh6njvfz4rkvc9r8p item_spec={"stringKeys":null,"stringValues":{"Name":"Trading Knife v3"},"dblKeys":null,"dblValues":null,"longKeys":null,"longValues":null} msg=no item exist which fit item spec
```
This log means there's no item with name `"Trading Knife v3"` that's owned by `cosmos1qzu2w5rkfs3vhenguupahhh6njvfz4rkvc9r8p` but it should exist.

- What's the meaning of this issue?  
```json
level=fatal owner_address=cosmos192a667s9dyz8qce3aau3ajt0xlgjs9jz53rmve item_spec={"stringKeys":null,"stringValues":{"Name":"Trading Knife v3"},"dblKeys":null,"dblValues":null,"longKeys":null,"longValues":null} msg=item exist but shouldn't exist
```
This log means there's an item with name `"Trading Knife v3"` that's owned by `cosmos1qzu2w5rkfs3vhenguupahhh6njvfz4rkvc9r8p` but it shouldn't exist.

- How to debug this issue?
```log
    TestFulfillTradeViaCLI/item->item_fullfill_trade_test: evtesting.go:359: level=debug action=func_end txhash=632A1A35933E4DDD89A71B2C576C7C9BD1267DA39A229B129981A64ED37CE9A6 signer=cosmos1gmze5z07hqwedp5jqnnta3cvmvpu3usl502d87 is_bech32=false tx_msg_type=MsgFulfillTrade tx_msg_sender=cosmos1gmze5z07hqwedp5jqnnta3cvmvpu3usl502d87 tx_msg_trade_id=cosmos1gmze5z07hqwedp5jqnnta3cvmvpu3usl502d8772fb8689-a1b2-45ab-a0d3-0d3c14cf6999 tx_msgs=[{"type":"pylons/FulfillTrade","value":{"TradeID":"cosmos1gmze5z07hqwedp5jqnnta3cvmvpu3usl502d8772fb8689-a1b2-45ab-a0d3-0d3c14cf6999","Sender":"cosmos1gmze5z07hqwedp5jqnnta3cvmvpu3usl502d87"}}] msg=debug log
         
    TestFulfillTradeViaCLI/item->item_fullfill_trade_test: evtesting.go:278: 
            Error Trace:    evtesting.go:278
                                        fulfill_trade_test.go:154
                                        fulfill_trade_test.go:115
                                        evtesting.go:101
            Error:          Should be true
            Test:           TestFulfillTradeViaCLI/item->item_fullfill_trade_test
--- FAIL: TestFulfillTradeViaCLI (0.00s)
    --- PASS: TestFulfillTradeViaCLI/coin->coin_fullfill_trade_test (17.38s)
    --- FAIL: TestFulfillTradeViaCLI/item->coin_fullfill_trade_test (16.74s)
    --- PASS: TestFulfillTradeViaCLI/coin->item_fullfill_trade_test (22.85s)
    --- FAIL: TestFulfillTradeViaCLI/item->item_fullfill_trade_test (28.66s)
```
Try to debug the transaction by doing `pylonscli query tx 632A1A35933E4DDD89A71B2C576C7C9BD1267DA39A229B129981A64ED37CE9A6`

- How to handle this issue?
```log
invalid request: the sender doesn't have the trade item attributes {ItemInput:{Doubles:DoubleInputParamList{} Longs:LongInputParamList{} Strings:StringInputParamList{Name: \n\tStringInputParam{ \n\t\tValue: TESTITEM_FulfillTrade__001_TC4_INPUT,\n\t},\n}} CookbookID:LOUD-CB-001}: failed to execute message; message index: 0
```
It means sender does not have an item with name `"TESTITEM_FulfillTrade__001_TC4_INPUT"` with cookbook ID `"LOUD-CB-001"`.
First check if cookbook with ID `"LOUD-CB-001"` and after that, check the item `"TESTITEM_FulfillTrade__001_TC4_INPUT"` on that cookbook.