
pylonsd init masternode --chain-id pylonschain
pylonscli config chain-id pylonschain
pylonscli config output json
pylonscli config indent true
pylonscli config trust-node true
pylonscli keys add jack 
pylonscli keys add alice
pylonsd add-genesis-account $(pylonscli keys show jack -a) 100pylon,1000jackcoin,100000000stake
pylonsd add-genesis-account $(pylonscli keys show alice -a) 100pylon,1000alicecoin,100000000stake
pylonsd gentx --name jack
pylonsd collect-gentxs
pylonsd start