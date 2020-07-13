pylonscli tx sign tx_validate_basic_error.json --from $(pylonscli keys show -a eugen --keyring-backend=test) --offline --chain-id pylonschain --sequence 1 --account-number 5 --keyring-backend test > signed_tx_validate_basic_error.json
pylonscli tx broadcast signed_tx_validate_basic_error.json

pylonscli tx pylons sign sample_txs/tx_sign_privkey.json --offline --account-number 0 --sequence 0 --private-key 276c784fe02abd8438cb9275ea22771dc7259b075d2404618ea6ec41736664c3