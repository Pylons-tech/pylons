## Google-IAP Walkthrough


pylonsd tx pylons google-iap-get-coins [productID] [purchaseToken] [recieptDataBase64] [signature] [flags]



# Google-IAP Get Pylons 
    ```
    productID: free_pylons
    purchaseToken: cbejaahehaalippbalkpbdli.AO-J1OyEOB7m9ZzlFq_ChJprKL6TzIfnyrge0rklyT2tQGdy7ETk4F-xxmCTBYyGUMyqZY0TiZVqeKvCc7Y5eNQDOjgILTkovw 
    recieptDataBase64: eyJvcmRlcklkIjoiR1BBLjMzMDYtNzU5MS0wMzk4LTgxMDY1IiwicGFja2FnZU5hbWUiOiJ0ZWNoLnB5bG9ucy53YWxsZXQiLCJwcm9kdWN0SWQiOiJmcmVlX3B5bG9ucyIsInB1cmNoYXNlVGltZSI6MTY1NDYxNTc3Nzc5OSwicHVyY2hhc2VTdGF0ZSI6MCwicHVyY2hhc2VUb2tlbiI6ImNiZWphYWhlaGFhbGlwcGJhbGtwYmRsaS5BTy1KMU95RU9CN205WnpsRnFfQ2hKcHJLTDZUeklmbnlyZ2UwcmtseVQydFFHZHk3RVRrNEYteHhtQ1RCWXlHVU15cVpZMFRpWlZxZUt2Q2M3WTVlTlFET2pnSUxUa292dyIsImFja25vd2xlZGdlZCI6ZmFsc2V9

    signature: O90FTzVlKiwRMasg0tgEF65tXoQi7BKOoA8K+2i1SuC0Mbi49Tw7JJAK6bHVXMqGn/urkANCJl1+Zu3vabp91SPLpT1hlVwzAC2NIRa5qs7D7DgAZiaRhqqP+01LNc3DKzxGWVThzT6Cq4PB0h2LyYDlZZBfGFXH9LAXd4e+lNTgewAs1zmBzWBDdFO1G8S7xxB373MgW9V9/rKZH1odyDaMBhbvhMgunmxdtmO6/MOuxkdg2FjvUxXzPTAmnUvoLEM2771caP5JAYxQNeejj2Te1QCTWZ1F66MIggJLEBBqq7sIafGRJ4zKHtpJyhR8iSKatzXcHrXMqUSqTs/W9Q==

    ```

# Google-IAP Request
```
pylonsd tx pylons google-iap-get-coins free_pylons cbejaahehaalippbalkpbdli.AO-J1OyEOB7m9ZzlFq_ChJprKL6TzIfnyrge0rklyT2tQGdy7ETk4F-xxmCTBYyGUMyqZY0TiZVqeKvCc7Y5eNQDOjgILTkovw  eyJvcmRlcklkIjoiR1BBLjMzMDYtNzU5MS0wMzk4LTgxMDY1IiwicGFja2FnZU5hbWUiOiJ0ZWNoLnB5bG9ucy53YWxsZXQiLCJwcm9kdWN0SWQiOiJmcmVlX3B5bG9ucyIsInB1cmNoYXNlVGltZSI6MTY1NDYxNTc3Nzc5OSwicHVyY2hhc2VTdGF0ZSI6MCwicHVyY2hhc2VUb2tlbiI6ImNiZWphYWhlaGFhbGlwcGJhbGtwYmRsaS5BTy1KMU95RU9CN205WnpsRnFfQ2hKcHJLTDZUeklmbnlyZ2UwcmtseVQydFFHZHk3RVRrNEYteHhtQ1RCWXlHVU15cVpZMFRpWlZxZUt2Q2M3WTVlTlFET2pnSUxUa292dyIsImFja25vd2xlZGdlZCI6ZmFsc2V9 O90FTzVlKiwRMasg0tgEF65tXoQi7BKOoA8K+2i1SuC0Mbi49Tw7JJAK6bHVXMqGn/urkANCJl1+Zu3vabp91SPLpT1hlVwzAC2NIRa5qs7D7DgAZiaRhqqP+01LNc3DKzxGWVThzT6Cq4PB0h2LyYDlZZBfGFXH9LAXd4e+lNTgewAs1zmBzWBDdFO1G8S7xxB373MgW9V9/rKZH1odyDaMBhbvhMgunmxdtmO6/MOuxkdg2FjvUxXzPTAmnUvoLEM2771caP5JAYxQNeejj2Te1QCTWZ1F66MIggJLEBBqq7sIafGRJ4zKHtpJyhR8iSKatzXcHrXMqUSqTs/W9Q== --from alice
```

confirm your transaction

```
confirm transaction before signing and broadcasting [y/N]: y

``

results 

```
code: 0
codespace: ""
data: 0A3A0A382F50796C6F6E73746563682E70796C6F6E732E70796C6F6E732E4D7367476F6F676C65496E4170705075726368617365476574436F696E73
events:
- attributes:
  - index: true
    key: YWNjX3NlcQ==
    value: cHlsbzF5Z3A0bmtzcXprdGZxbDluM3FqYXF2ZThyMm4zc3dtbnoyeXM5bC8z
  type: tx
- attributes:
  - index: true
    key: c2lnbmF0dXJl
    value: ajZIK0xzVEdmTnl2Y0FqcUJid2dXTmpzaTJCcCtDN0hkdFphdjRLQXZLaHZHdjVVbGNaNU4rVzliKzkxOWk4L013eHNQRTJ5S3h6NjFSQlRUNW5PRVE9PQ==
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
    value: cHlsbzF5Z3A0bmtzcXprdGZxbDluM3FqYXF2ZThyMm4zc3dtbnoyeXM5bA==
  - index: true
    key: YW1vdW50
    value: MTAwMHVweWxvbg==
  type: coin_received
- attributes:
  - index: true
    key: cmVjaXBpZW50
    value: cHlsbzF5Z3A0bmtzcXprdGZxbDluM3FqYXF2ZThyMm4zc3dtbnoyeXM5bA==
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
    key: c2lnbmF0dXJl
    value: Ik85MEZUelZsS2l3Uk1hc2cwdGdFRjY1dFhvUWk3QktPb0E4SysyaTFTdUMwTWJpNDlUdzdKSkFLNmJIVlhNcUduL3Vya0FOQ0psMStadTN2YWJwOTFTUExwVDFobFZ3ekFDMk5JUmE1cXM3RDdEZ0FaaWFSaHFxUCswMUxOYzNES3p4R1dWVGh6VDZDcTRQQjBoMkx5WURsWlpCZkdGWEg5TEFYZDRlK2xOVGdld0FzMXptQnpXQkRkRk8xRzhTN3h4QjM3M01nVzlWOS9yS1pIMW9keURhTUJoYnZoTWd1bm14ZHRtTzYvTU91eGtkZzJGanZVeFh6UFRBbW5Vdm9MRU0yNzcxY2FQNUpBWXhRTmVlamoyVGUxUUNUV1oxRjY2TUlnZ0pMRUJCcXE3c0lhZkdSSjR6S0h0cEp5aFI4aVNLYXR6WGNIclhNcVVTcVRzL1c5UT09Ig==
  - index: true
    key: Y3JlYXRvcg==
    value: InB5bG8xeWdwNG5rc3F6a3RmcWw5bjNxamFxdmU4cjJuM3N3bW56MnlzOWwi
  - index: true
    key: cHJvZHVjdElE
    value: ImZyZWVfcHlsb25zIg==
  - index: true
    key: cHVyY2hhc2VUb2tlbg==
    value: ImNiZWphYWhlaGFhbGlwcGJhbGtwYmRsaS5BTy1KMU95RU9CN205WnpsRnFfQ2hKcHJLTDZUeklmbnlyZ2UwcmtseVQydFFHZHk3RVRrNEYteHhtQ1RCWXlHVU15cVpZMFRpWlZxZUt2Q2M3WTVlTlFET2pnSUxUa292dyI=
  - index: true
    key: cmVjZWlwdERhdGFCYXNlNjQ=
    value: ImV5SnZjbVJsY2tsa0lqb2lSMUJCTGpNek1EWXROelU1TVMwd016azRMVGd4TURZMUlpd2ljR0ZqYTJGblpVNWhiV1VpT2lKMFpXTm9MbkI1Ykc5dWN5NTNZV3hzWlhRaUxDSndjbTlrZFdOMFNXUWlPaUptY21WbFgzQjViRzl1Y3lJc0luQjFjbU5vWVhObFZHbHRaU0k2TVRZMU5EWXhOVGMzTnpjNU9Td2ljSFZ5WTJoaGMyVlRkR0YwWlNJNk1Dd2ljSFZ5WTJoaGMyVlViMnRsYmlJNkltTmlaV3BoWVdobGFHRmhiR2x3Y0dKaGJHdHdZbVJzYVM1QlR5MUtNVTk1UlU5Q04yMDVXbnBzUm5GZlEyaEtjSEpMVERaVWVrbG1ibmx5WjJVd2NtdHNlVlF5ZEZGSFpIazNSVlJyTkVZdGVIaHRRMVJDV1hsSFZVMTVjVnBaTUZScFdsWnhaVXQyUTJNM1dUVmxUbEZFVDJwblNVeFVhMjkyZHlJc0ltRmphMjV2ZDJ4bFpHZGxaQ0k2Wm1Gc2MyVjki
  type: Pylonstech.pylons.pylons.EventGooglePurchase
gas_used: "81440"
gas_wanted: "200000"
height: "87"
info: ""
logs:
- events:
  - attributes:
    - key: signature
      value: '"O90FTzVlKiwRMasg0tgEF65tXoQi7BKOoA8K+2i1SuC0Mbi49Tw7JJAK6bHVXMqGn/urkANCJl1+Zu3vabp91SPLpT1hlVwzAC2NIRa5qs7D7DgAZiaRhqqP+01LNc3DKzxGWVThzT6Cq4PB0h2LyYDlZZBfGFXH9LAXd4e+lNTgewAs1zmBzWBDdFO1G8S7xxB373MgW9V9/rKZH1odyDaMBhbvhMgunmxdtmO6/MOuxkdg2FjvUxXzPTAmnUvoLEM2771caP5JAYxQNeejj2Te1QCTWZ1F66MIggJLEBBqq7sIafGRJ4zKHtpJyhR8iSKatzXcHrXMqUSqTs/W9Q=="'
    - key: creator
      value: '"pylo1ygp4nksqzktfql9n3qjaqve8r2n3swmnz2ys9l"'
    - key: productID
      value: '"free_pylons"'
    - key: purchaseToken
      value: '"cbejaahehaalippbalkpbdli.AO-J1OyEOB7m9ZzlFq_ChJprKL6TzIfnyrge0rklyT2tQGdy7ETk4F-xxmCTBYyGUMyqZY0TiZVqeKvCc7Y5eNQDOjgILTkovw"'
    - key: receiptDataBase64
      value: '"eyJvcmRlcklkIjoiR1BBLjMzMDYtNzU5MS0wMzk4LTgxMDY1IiwicGFja2FnZU5hbWUiOiJ0ZWNoLnB5bG9ucy53YWxsZXQiLCJwcm9kdWN0SWQiOiJmcmVlX3B5bG9ucyIsInB1cmNoYXNlVGltZSI6MTY1NDYxNTc3Nzc5OSwicHVyY2hhc2VTdGF0ZSI6MCwicHVyY2hhc2VUb2tlbiI6ImNiZWphYWhlaGFhbGlwcGJhbGtwYmRsaS5BTy1KMU95RU9CN205WnpsRnFfQ2hKcHJLTDZUeklmbnlyZ2UwcmtseVQydFFHZHk3RVRrNEYteHhtQ1RCWXlHVU15cVpZMFRpWlZxZUt2Q2M3WTVlTlFET2pnSUxUa292dyIsImFja25vd2xlZGdlZCI6ZmFsc2V9"'
    type: Pylonstech.pylons.pylons.EventGooglePurchase
  - attributes:
    - key: receiver
      value: pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr
    - key: amount
      value: 1000upylon
    - key: receiver
      value: pylo1ygp4nksqzktfql9n3qjaqve8r2n3swmnz2ys9l
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
      value: pylo1ygp4nksqzktfql9n3qjaqve8r2n3swmnz2ys9l
    - key: sender
      value: pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr
    - key: amount
      value: 1000upylon
    type: transfer
  log: ""
  msg_index: 0
raw_log: '[{"events":[{"type":"Pylonstech.pylons.pylons.EventGooglePurchase","attributes":[{"key":"signature","value":"\"O90FTzVlKiwRMasg0tgEF65tXoQi7BKOoA8K+2i1SuC0Mbi49Tw7JJAK6bHVXMqGn/urkANCJl1+Zu3vabp91SPLpT1hlVwzAC2NIRa5qs7D7DgAZiaRhqqP+01LNc3DKzxGWVThzT6Cq4PB0h2LyYDlZZBfGFXH9LAXd4e+lNTgewAs1zmBzWBDdFO1G8S7xxB373MgW9V9/rKZH1odyDaMBhbvhMgunmxdtmO6/MOuxkdg2FjvUxXzPTAmnUvoLEM2771caP5JAYxQNeejj2Te1QCTWZ1F66MIggJLEBBqq7sIafGRJ4zKHtpJyhR8iSKatzXcHrXMqUSqTs/W9Q==\""},{"key":"creator","value":"\"pylo1ygp4nksqzktfql9n3qjaqve8r2n3swmnz2ys9l\""},{"key":"productID","value":"\"free_pylons\""},{"key":"purchaseToken","value":"\"cbejaahehaalippbalkpbdli.AO-J1OyEOB7m9ZzlFq_ChJprKL6TzIfnyrge0rklyT2tQGdy7ETk4F-xxmCTBYyGUMyqZY0TiZVqeKvCc7Y5eNQDOjgILTkovw\""},{"key":"receiptDataBase64","value":"\"eyJvcmRlcklkIjoiR1BBLjMzMDYtNzU5MS0wMzk4LTgxMDY1IiwicGFja2FnZU5hbWUiOiJ0ZWNoLnB5bG9ucy53YWxsZXQiLCJwcm9kdWN0SWQiOiJmcmVlX3B5bG9ucyIsInB1cmNoYXNlVGltZSI6MTY1NDYxNTc3Nzc5OSwicHVyY2hhc2VTdGF0ZSI6MCwicHVyY2hhc2VUb2tlbiI6ImNiZWphYWhlaGFhbGlwcGJhbGtwYmRsaS5BTy1KMU95RU9CN205WnpsRnFfQ2hKcHJLTDZUeklmbnlyZ2UwcmtseVQydFFHZHk3RVRrNEYteHhtQ1RCWXlHVU15cVpZMFRpWlZxZUt2Q2M3WTVlTlFET2pnSUxUa292dyIsImFja25vd2xlZGdlZCI6ZmFsc2V9\""}]},{"type":"coin_received","attributes":[{"key":"receiver","value":"pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr"},{"key":"amount","value":"1000upylon"},{"key":"receiver","value":"pylo1ygp4nksqzktfql9n3qjaqve8r2n3swmnz2ys9l"},{"key":"amount","value":"1000upylon"}]},{"type":"coin_spent","attributes":[{"key":"spender","value":"pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr"},{"key":"amount","value":"1000upylon"}]},{"type":"coinbase","attributes":[{"key":"minter","value":"pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr"},{"key":"amount","value":"1000upylon"}]},{"type":"message","attributes":[{"key":"action","value":"GoogleIAPGetCoins"},{"key":"sender","value":"pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr"}]},{"type":"transfer","attributes":[{"key":"recipient","value":"pylo1ygp4nksqzktfql9n3qjaqve8r2n3swmnz2ys9l"},{"key":"sender","value":"pylo1su6smltps3c342ppsp6mtrp9dt90vjnvvesrfr"},{"key":"amount","value":"1000upylon"}]}]}]'
timestamp: ""
tx: null
txhash: A6BBF0DC26DFD567E987214591C81B556350C0C52A809BE70007334F3208D6AE
```