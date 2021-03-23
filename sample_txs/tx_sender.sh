
for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
do
  echo "Running $i times"
  pylonsd tx send $(pylonsd keys show -a eugen --keyring-backend=test) cosmos13p8890funv54hflk82ju0zv47tspglpk373453 1000pylon --keyring-backend=test --generate-only > tx_send_$i.json
  pylonsd tx sign tx_send_$i.json --from $(pylonsd keys show -a eugen --keyring-backend=test) --offline --chain-id pylonschain --sequence $i --account-number 45 --keyring-backend test > signed_tx_send_$i.json
  pylonsd tx broadcast signed_tx_send_$i.json
done
