## Perform this after Disabling Validations in `google-iap-get-coins`


pylonsd tx pylons google-iap-get-coins [productID] [purchaseToken] [recieptDataBase64] [signature] [flags]


# Sample 
## 1 : Get Coin Issuers
    ```
    ➜  pylonsd git:(Verify-IAP) ✗ pylonsd query pylons list-coin-issuers
    IssuersList:
    - coinDenom: upylon
    entityName: Pylons_Inc
    googleInAppPurchasePubKey: MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwZsjhk6eN5Pve9pP3uqz2MwBFixvmCRtQJoDQLTEJo3zTd9VMZcXoerQX8cnDPclZWmMZWkO+BWcN1ikYdGHvU2gC7yBLi+TEkhsEkixMlbqOGRdmNptJJhqxuVmXK+drWTb6W0IgQ9g8CuCjZUiMTc0UjHb5mPOE/IhcuTZ0wCHdoqc5FS2spdQqrohvSEP7gR4ZgGzYNI1U+YZHskIEm2qC4ZtSaX9J/fDkAmmJFV2hzeDMcljCxY9+ZM1mdzIpZKwM7O6UdWRpwD1QJ7yXND8AQ9M46p16F0VQuZbbMKCs90NIcKkx6jDDGbVmJrFnUT1Oq1uYxNYtiZjTp+JowIDAQAB
    packages:
    - amount: "1000"
        packageName: com.pylons.loud
        productID: pylons_1000
    - amount: "55000"
        packageName: com.pylons.loud
        productID: pylons_55000
    ```

## 2 : Compile JSON to Base64
    
    - JSON : `{"purchaseToken":"ptoken10","productId":"pylons_1000"}`
    - JSON Converted to BASE64 : `eyJwdXJjaGFzZVRva2VuIjoicHRva2VuMTAiLCJwcm9kdWN0SWQiOiJweWxvbnNfMTAwMCJ9`

## 3 : Setup transaction

    - add random unique purchase token

    - ``` 
      pylonsd tx pylons google-iap-get-coins pylons_1000 ptoken10 eyJwdXJjaGFzZVRva2VuIjoicHRva2VuMTAiLCJwcm9kdWN0SWQiOiJweWxvbnNfMTAwMCJ9 randomSignature --from alice
      ```


## 4 : Result 
    
    ```
    ➜  pylonsd git:(Verify-IAP) ✗ pylonsd tx pylons google-iap-get-coins pylons_1000 ptoken10 eyJwdXJjaGFzZVRva2VuIjoicHRva2VuMTAiLCJwcm9kdWN0SWQiOiJweWxvbnNfMTAwMCJ9 randomSignature --from alice
    {"body":{"messages":[{"@type":"/Pylonstech.pylons.pylons.MsgGoogleInAppPurchaseGetCoins","creator":"pylo1vq97quk7ewncqlx7lwth2eslaq7pv93fgdzcj6","productID":"pylons_1000","purchaseToken":"ptoken10","receiptDataBase64":"eyJwdXJjaGFzZVRva2VuIjoicHRva2VuMTAiLCJwcm9kdWN0SWQiOiJweWxvbnNfMTAwMCJ9","signature":"randomSignature"}],"memo":"","timeout_height":"0","extension_options":[],"non_critical_extension_options":[]},"auth_info":{"signer_infos":[],"fee":{"amount":[],"gas_limit":"200000","payer":"","granter":""}},"signatures":[]}

    confirm transaction before signing and broadcasting [y/N]: y
    code: 0
    codespace: ""
    data: 0A3A0A382F50796C6F6E73746563682E70796C6F6E732E70796C6F6E732E4D7367476F6F676C65496E4170705075726368617365476574436F696E73
    events:
    - attributes:
      - index: true
        key: YWNjX3NlcQ==
        value: cHlsbzF2cTk3cXVrN2V3bmNxbHg3bHd0aDJlc2xhcTdwdjkzZmdkemNqNi8y
      type: tx
    - attributes:
      - index: true
        key: c2lnbmF0dXJl
        value: d1lFSzdQdG5HbFhya2lkWXFhaHh1VVFWb0V1N0V0c0ZiNG91aGdwbktmWTFxaC9nSXI1cnQzMS9MSlVGWGQ1SUhYOGtHejhwN0ZqZGZueGtEdUR4Ymc9PQ==
      type: tx
    - attributes:
      - index: true
        key: YWN0aW9u
        value: R29vZ2xlSUFQR2V0Q29pbnM=
      type: message
    - attributes:
      - index: true
        key: cmVjZWl2ZXI=
        value: cHlsbzFzdTZzbWx0cHMzYzM0MnBwc3A2bXRycDlkdDkwdmpudnZlc3Jmcg==
      - index: true
        key: YW1vdW50
        value: MTAwMHVweWxvbg==
      type: coin_received
    - attributes:
      - index: true
        key: bWludGVy
        value: cHlsbzFzdTZzbWx0cHMzYzM0MnBwc3A2bXRycDlkdDkwdmpudnZlc3Jmcg==
      - index: true
        key: YW1vdW50
        value: MTAwMHVweWxvbg==
      type: coinbase
    - attributes:
      - index: true
        key: c3BlbmRlcg==
        value: cHlsbzFzdTZzbWx0cHMzYzM0MnBwc3A2bXRycDlkdDkwdmpudnZlc3Jmcg==
      - index: true
        key: YW1vdW50
        value: MTAwMHVweWxvbg==
      type: coin_spent
    - attributes:
      - index: true
        key: cmVjZWl2ZXI=
        value: cHlsbzF2cTk3cXVrN2V3bmNxbHg3bHd0aDJlc2xhcTdwdjkzZmdkemNqNg==
      - index: true
        key: YW1vdW50
        value: MTAwMHVweWxvbg==
      type: coin_received
    - attributes:
      - index: true
        key: cmVjaXBpZW50
        value: cHlsbzF2cTk3cXVrN2V3bmNxbHg3bHd0aDJlc2xhcTdwdjkzZmdkemNqNg==
      - index: true
        key: c2VuZGVy
        value: cHlsbzFzdTZzbWx0cHMzYzM0MnBwc3A2bXRycDlkdDkwdmpudnZlc3Jmcg==
      - index: true
        key: YW1vdW50
        value: MTAwMHVweWxvbg==
      type: transfer
    - attributes:
      - index: true
        key: c2VuZGVy
        value: cHlsbzFzdTZzbWx0cHMzYzM0MnBwc3A2bXRycDlkdDkwdmpudnZlc3Jmcg==
      type: message
    - attributes:
      - index: true
        key: cHJvZHVjdElE
        value: InB5bG9uc18xMDAwIg==
      - index: true
        key: cHVyY2hhc2VUb2tlbg==
        value: InB0b2tlbjEwIg==
      - index: true
        key: cmVjZWlwdERhdGFCYXNlNjQ=
        value: ImV5SndkWEpqYUdGelpWUnZhMlZ1SWpvaWNIUnZhMlZ1TVRBaUxDSndjbTlrZFdOMFNXUWlPaUp3ZVd4dmJuTmZNVEF3TUNKOSI=
      - index: true
        key: c2lnbmF0dXJl
        value: InJhbmRvbVNpZ25hdHVyZSI=
      - index: true
        key: Y3JlYXRvcg==
        value: InB5bG8xdnE5N3F1azdld25jcWx4N2x3dGgyZXNsYXE3cHY5M2ZnZHpjajYi
      type: Pylonstech.pylons.pylons.EventGooglePurchase
    gas_used: "60780"
    gas_wanted: "200000"
    height: "6365"
    info: ""
    logs:
    - events:
      - attributes:
        - key: productID
          value: '"pylons_1000"'
        - key: purchaseToken
          value: '"ptoken10"'
        - key: receiptDataBase64
          value: '"eyJwdXJjaGFzZVRva2VuIjoicHRva2VuMTAiLCJwcm9kdWN0SWQiOiJweWxvbnNfMTAwMCJ9"'
        - key: signature
          value: '"randomSignature"'
        - key: creator
          value: '"pylo1vq97quk7ewncqlx7lwth2eslaq7pv93fgdzcj6"'
        type: Pylonstech.pylons.pylons.EventGooglePurchase
      - attributes:
        - key: receiver
          value: pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr
        - key: amount
          value: 1000upylon
        - key: receiver
          value: pylo1vq97quk7ewncqlx7lwth2eslaq7pv93fgdzcj6
        - key: amount
          value: 1000upylon
        type: coin_received
      - attributes:
        - key: spender
          value: pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr
        - key: amount
          value: 1000upylon
        type: coin_spent
      - attributes:
        - key: minter
          value: pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr
        - key: amount
          value: 1000upylon
        type: coinbase
      - attributes:
        - key: action
          value: GoogleIAPGetCoins
        - key: sender
          value: pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr
        type: message
      - attributes:
        - key: recipient
          value: pylo1vq97quk7ewncqlx7lwth2eslaq7pv93fgdzcj6
        - key: sender
          value: pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr
        - key: amount
          value: 1000upylon
        type: transfer
      log: ""
      msg_index: 0
    raw_log: '[{"events":[{"type":"Pylonstech.pylons.pylons.EventGooglePurchase","attributes":[{"key":"productID","value":"\"pylons_1000\""},{"key":"purchaseToken","value":"\"ptoken10\""},{"key":"receiptDataBase64","value":"\"eyJwdXJjaGFzZVRva2VuIjoicHRva2VuMTAiLCJwcm9kdWN0SWQiOiJweWxvbnNfMTAwMCJ9\""},{"key":"signature","value":"\"randomSignature\""},{"key":"creator","value":"\"pylo1vq97quk7ewncqlx7lwth2eslaq7pv93fgdzcj6\""}]},{"type":"coin_received","attributes":[{"key":"receiver","value":"pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr"},{"key":"amount","value":"1000upylon"},{"key":"receiver","value":"pylo1vq97quk7ewncqlx7lwth2eslaq7pv93fgdzcj6"},{"key":"amount","value":"1000upylon"}]},{"type":"coin_spent","attributes":[{"key":"spender","value":"pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr"},{"key":"amount","value":"1000upylon"}]},{"type":"coinbase","attributes":[{"key":"minter","value":"pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr"},{"key":"amount","value":"1000upylon"}]},{"type":"message","attributes":[{"key":"action","value":"GoogleIAPGetCoins"},{"key":"sender","value":"pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr"}]},{"type":"transfer","attributes":[{"key":"recipient","value":"pylo1vq97quk7ewncqlx7lwth2eslaq7pv93fgdzcj6"},{"key":"sender","value":"pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr"},{"key":"amount","value":"1000upylon"}]}]}]'
    timestamp: ""
    tx: null
    txhash: 086B4B77D848CE8F922745A3447B1EEBC24A5245E32218EF7B8E1637CF4142BD
    
    ```


