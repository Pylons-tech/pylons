pylonscli tx send $(pylonscli keys show -a eugen --keyring-backend=test) cosmos13p8890funv54hflk82ju0zv47tspglpk373453 1000pylon --keyring-backend=test --generate-only > tx_send1.json
pylonscli tx sign tx_send1.json --from $(pylonscli keys show -a eugen --keyring-backend=test) --offline --chain-id pylonschain --sequence 0 --account-number 45 --keyring-backend test > signed_tx_send1.json
pylonscli tx broadcast signed_tx_send1.json
pylonscli query account $(pylonscli keys show -a eugen --keyring-backend=test)

pylonscli tx send $(pylonscli keys show -a eugen --keyring-backend=test) cosmos13p8890funv54hflk82ju0zv47tspglpk373453 100pylon --keyring-backend=test --generate-only > tx_send2.json
pylonscli tx sign tx_send2.json --from $(pylonscli keys show -a eugen --keyring-backend=test) --offline --chain-id pylonschain --sequence 1 --account-number 45 --keyring-backend test > signed_tx_send2.json
pylonscli tx broadcast signed_tx_send2.json
pylonscli query account $(pylonscli keys show -a eugen --keyring-backend=test)

pylonscli tx send $(pylonscli keys show -a eugen --keyring-backend=test) cosmos13p8890funv54hflk82ju0zv47tspglpk373453 10pylon --keyring-backend=test --generate-only > tx_send3.json
pylonscli tx sign tx_send3.json --from $(pylonscli keys show -a eugen --keyring-backend=test) --offline --chain-id pylonschain --sequence 2 --account-number 45 --keyring-backend test > signed_tx_send3.json
pylonscli tx broadcast signed_tx_send3.json
pylonscli query account $(pylonscli keys show -a eugen --keyring-backend=test)